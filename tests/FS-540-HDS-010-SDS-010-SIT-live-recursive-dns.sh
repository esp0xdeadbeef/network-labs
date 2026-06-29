#!/usr/bin/env bash
# GAMP-ID: FS-540-HDS-010-SDS-010
# GAMP-SCOPE: focused live SIT probe for active-lab recursive DNS; not a HAT runner
set -euo pipefail

nixos_host="${S_ROUTER_NIXOS:-s-router-nixos}"
clab_host="${S_ROUTER_CLAB:-s-router-clab}"
query_name="${FS540_DNS_QUERY:-cache.nixos.org}"
trace_id="FS-540-HDS-010-SDS-010"
failures=0

if ! [[ "${query_name}" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "FAIL ${trace_id}: unsafe DNS query name: ${query_name}" >&2
  exit 64
fi

record_failure() {
  echo "FAIL ${trace_id}: $*" >&2
  failures=$((failures + 1))
}

ssh_base() {
  ssh -n \
    -o BatchMode=yes \
    -o ConnectTimeout=5 \
    -o StrictHostKeyChecking=accept-new \
    "root@$1" \
    "$2"
}

check_artifact_resolver_sources() {
  local surface="$1"
  local host="$2"
  local artifact="$3"
  local counts local_recursive upstream dhcp none

  counts="$(ssh_base "${host}" "set -euo pipefail
    test -f '${artifact}'
    jq -r '
      [.. | objects | select((.dnsResolver? | type) == \"object\") | .dnsResolver.resolverSource] as \$sources
      | [
          (\$sources | map(select(. == \"local-recursive\")) | length),
          (\$sources | map(select(. == \"upstream-forwarder\")) | length),
          (\$sources | map(select(. == \"dhcp-provided\")) | length),
          (\$sources | map(select(. == \"none\")) | length)
        ]
      | @tsv
    ' '${artifact}'
  ")" || {
    record_failure "${surface}: cannot read resolver-source counts from ${artifact}"
    return
  }

  read -r local_recursive upstream dhcp none <<<"${counts}"
  [[ "${local_recursive}" -gt 0 ]] || record_failure "${surface}: no local-recursive dnsResolver entries"
  [[ "${upstream}" -gt 0 ]] || record_failure "${surface}: no upstream-forwarder dnsResolver entries"
  [[ "${none}" -gt 0 ]] || record_failure "${surface}: no none dnsResolver entries"

  echo "PASS ${trace_id} ${surface} resolver-source artifact counts: local-recursive=${local_recursive} upstream-forwarder=${upstream} dhcp-provided=${dhcp} none=${none}"
}

check_nixos_recursive_container() {
  local container="$1"
  local output

  output="$(ssh_base "${nixos_host}" "timeout 18 nixos-container run '${container}' -- sh -lc '
    set -eu
    grep -Fx \"nameserver 127.0.0.1\" /etc/resolv.conf
    grep -Fx \"nameserver ::1\" /etc/resolv.conf
    test \"\$(systemctl is-active unbound 2>/dev/null)\" = active
    ss -lntup 2>/dev/null | grep -E \"127[.]0[.]0[.]1:53|[[]::1[]]:53|[[]::1[]]:53\"
    dig +time=2 +tries=1 @127.0.0.1 '${query_name}' A > /tmp/fs540-dig.out 2>&1
    grep -F \"status: NOERROR\" /tmp/fs540-dig.out
  '" 2>&1)" || {
    record_failure "s-router-nixos ${container}: local recursive DNS did not resolve ${query_name}"
    printf '%s\n' "${output}" >&2
    return
  }

  echo "PASS ${trace_id} s-router-nixos ${container} recursive DNS resolves ${query_name}"
}

check_clab_recursive_container() {
  local container="$1"
  local output

  output="$(ssh_base "${clab_host}" "docker exec '${container}' sh -lc '
    set -eu
    grep -Fx \"nameserver 127.0.0.1\" /etc/resolv.conf
    grep -Fx \"nameserver ::1\" /etc/resolv.conf
    ss -lntup 2>/dev/null | grep -E \"127[.]0[.]0[.]1:53|[[]::1[]]:53|[[]::1[]]:53\"
    timeout 3 getent hosts '${query_name}' >/tmp/fs540-getent.out 2>/tmp/fs540-getent.err
    test -s /tmp/fs540-getent.out
  '" 2>&1)" || {
    record_failure "s-router-clab ${container}: local recursive DNS did not resolve ${query_name}"
    printf '%s\n' "${output}" >&2
    return
  }

  echo "PASS ${trace_id} s-router-clab ${container} recursive DNS resolves ${query_name}"
}

check_clab_no_docker_host_resolver_fallback() {
  local container="$1"
  local output

  output="$(ssh_base "${clab_host}" "docker exec '${container}' sh -lc '
    set -eu
    if grep -E \"^nameserver (1[.]1[.]1[.]1|8[.]8[.]8[.]8|9[.]9[.]9[.]9|192[.]168[.]1[.]1)\" /etc/resolv.conf; then
      exit 42
    fi
  '" 2>&1)" || {
    record_failure "s-router-clab ${container}: inherited Docker/host public resolver fallback"
    printf '%s\n' "${output}" >&2
    return
  }

  echo "PASS ${trace_id} s-router-clab ${container} does not inherit Docker/host public resolver fallback"
}

check_artifact_resolver_sources \
  s-router-nixos \
  "${nixos_host}" \
  /etc/network-artifacts/control-plane.json

check_artifact_resolver_sources \
  s-router-clab \
  "${clab_host}" \
  /persist/s-router-clab/live-boot/network-artifacts/control-plane.json

for container in \
  nixos-router-access-client \
  nixos-router-access-admin \
  nixos-router-core-nebula
do
  check_nixos_recursive_container "${container}"
done

for container in \
  clab-fabric-esp-clab-clab-router-access-client \
  clab-fabric-esp-clab-clab-router-access-admin
do
  check_clab_recursive_container "${container}"
done

check_clab_no_docker_host_resolver_fallback \
  clab-fabric-esp-clab-clab-router-core-nebula

if [[ "${failures}" -ne 0 ]]; then
  echo "FAIL ${trace_id}: live recursive DNS SIT failed with ${failures} finding(s)" >&2
  exit 1
fi

echo "PASS ${trace_id} live recursive DNS SIT"
