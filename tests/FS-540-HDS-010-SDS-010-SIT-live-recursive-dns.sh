#!/usr/bin/env bash
# GAMP-ID: FS-540-HDS-010-SDS-010
# GAMP-SCOPE: focused live SIT probe for active-lab recursive DNS; not a HAT runner
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
nixos_host="${S_ROUTER_NIXOS:-s-router-nixos}"
clab_host="${S_ROUTER_CLAB:-s-router-clab}"
query_name="${FS540_DNS_QUERY:-cache.nixos.org}"
trace_id="FS-540-HDS-010-SDS-010"
failures=0

fail_fast() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

if ! [[ "${query_name}" =~ ^[A-Za-z0-9._-]+$ ]]; then
  fail_fast "unsafe DNS query name: ${query_name}"
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

discover_nixos_container() {
  local suffix="$1"
  ssh_base "${nixos_host}" "nixos-container list 2>/dev/null | awk 'NF && \$1 != \"Name\" { print \$1 }' | grep -E '(^|-)${suffix}\$' | head -n 1"
}

discover_clab_container() {
  local suffix="$1"
  ssh_base "${clab_host}" "docker ps --format '{{.Names}}' | grep -E '(^|-)${suffix}\$' | head -n 1"
}

discover_clab_lab_emulation_container() {
  ssh_base "${clab_host}" "docker ps --format '{{.Names}}' | grep -E '(^|-)lab-emulation-fs540-dns-resolver-testnet\$' | head -n 1"
}

check_current_lab_selection() {
  if [[ "${FS540_SKIP_LOCAL_SELECTION_GUARD:-0}" == "1" ]]; then
    echo "WARN ${trace_id}: local current-lab selection guard skipped" >&2
    return
  fi

  nix eval --impure --expr "
    let
      current = import ${repo_root}/current-lab;
      inventory = import ${repo_root}/current-lab/inventory-nixos.nix;
      manifest = import ${repo_root}/GAMP/SMT/mini-smt/tests.nix;
      entry = manifest.tests.\"dns-resolver-config\";
      nodes = builtins.attrNames (inventory.realization.nodes or { });
      expectedNodes = [
        \"mini-smt-dns-resolver-config-access-dns\"
        \"mini-smt-dns-resolver-config-downstream-selector\"
        \"mini-smt-dns-resolver-config-policy\"
        \"mini-smt-dns-resolver-config-resolver-node\"
        \"mini-smt-dns-resolver-config-upstream-selector\"
      ];
      selected =
        (
          current.selection.layer == \"SIT\"
          && current.selection.selector == \"FS-540-HDS-010-SDS-010\"
        )
        || (
          current.selection.layer == \"SMT\"
          && current.selection.selector == \"dns-resolver-config\"
        )
        || (
          current.selection.layer == \"SMT\"
          && current.selection.traceId == \"FS-540-HDS-010-SDS-010-SMS-020\"
        );
      require = cond: msg: if cond then true else throw msg;
    in
      require selected
        \"FS-540 live SIT requires current-lab selected to SIT FS-540-HDS-010-SDS-010 or SMT dns-resolver-config; run scripts/select-current-lab.sh SIT FS-540-HDS-010-SDS-010\"
      && require (entry.maxRuntimeTargets == 5)
        \"FS-540 dns-resolver-config manifest must cap the live mini path at five runtime targets\"
      && require (builtins.length nodes <= entry.maxRuntimeTargets)
        \"FS-540 selected current-lab expands beyond the mini runtime target cap\"
      && require (nodes == expectedNodes)
        \"FS-540 selected current-lab must be exactly the five-node requester-policy-resolver mini path\"
  " >/dev/null || fail_fast "current-lab is not the FS-540 mini SIT selection"
}

check_artifact_mini_scope() {
  local surface="$1"
  local host="$2"
  local artifact="$3"
  local renderer_key="$4"
  local summary count has_access has_resolver names

  summary="$(ssh_base "${host}" "set -euo pipefail
    test -f '${artifact}'
    jq -r --arg renderer '${renderer_key}' '
      (
        .control_plane_model.data.\"mini-smt\".\"dns-resolver-config\".runtimeTargets
        // .control_plane_model.data.esp[\$renderer].runtimeTargets
        // .control_plane_model.runtimeTargets
        // .runtimeTargets
        // {}
      ) as \$targets
      | (\$targets | keys | sort) as \$names
      | [
          (\$names | length),
          (any(\$names[]; test(\"(^|-)access-dns$\"))),
          (any(\$names[]; test(\"(^|-)resolver-node$\"))),
          (\$names | join(\",\"))
        ]
      | @tsv
    ' '${artifact}'
  ")" || {
    record_failure "${surface}: cannot inspect mini runtime target scope from ${artifact}"
    return
  }

  IFS=$'\t' read -r count has_access has_resolver names <<<"${summary}"
  [[ "${count}" -gt 0 ]] || record_failure "${surface}: artifact has no runtime target scope"
  [[ "${count}" -le 5 ]] || record_failure "${surface}: artifact is not the FS-540 mini topology; runtimeTargets=${count} names=${names}"
  [[ "${has_access}" == "true" ]] || record_failure "${surface}: artifact missing access-dns runtime target; names=${names}"
  [[ "${has_resolver}" == "true" ]] || record_failure "${surface}: artifact missing resolver-node runtime target; names=${names}"

  if [[ "${count}" -gt 0 && "${count}" -le 5 && "${has_access}" == "true" && "${has_resolver}" == "true" ]]; then
    echo "PASS ${trace_id} ${surface} artifact runtime scope: runtimeTargets=${count} names=${names}"
  fi
}

check_artifact_resolver_sources() {
  local surface="$1"
  local host="$2"
  local artifact="$3"
  local counts local_recursive upstream dhcp none public_fallback access_local non_access_local

  counts="$(ssh_base "${host}" "set -euo pipefail
    test -f '${artifact}'
    jq -r '
      (
        .control_plane_model.data.\"mini-smt\".\"dns-resolver-config\".runtimeTargets
        // .control_plane_model.runtimeTargets
        // .runtimeTargets
        // {}
      ) as \$targets
      | [
          \$targets
          | to_entries[]
          | {
              name: .key,
              sources: ([.value | .. | objects | select((.dnsResolver? | type) == \"object\") | .dnsResolver.resolverSource])
            }
        ] as \$targetSources
      | [\$targetSources[] | .sources[]] as \$sources
      | [
          (\$sources | map(select(. == \"local-recursive\")) | length),
          (\$sources | map(select(. == \"upstream-forwarder\")) | length),
          (\$sources | map(select(. == \"dhcp-provided\")) | length),
          (\$sources | map(select(. == \"none\")) | length),
          (\$sources | map(select(. == \"public-fallback\")) | length),
          (\$targetSources | map(select(.name | test(\"(^|-)access-dns$\")) | .sources[] | select(. == \"local-recursive\")) | length),
          (\$targetSources | map(select(.name | test(\"(^|-)access-dns$\") | not) | .sources[] | select(. == \"local-recursive\")) | length)
        ]
      | @tsv
    ' '${artifact}'
  ")" || {
    record_failure "${surface}: cannot read resolver-source counts from ${artifact}"
    return
  }

  read -r local_recursive upstream dhcp none public_fallback access_local non_access_local <<<"${counts}"
  [[ "${local_recursive}" -gt 0 ]] || record_failure "${surface}: no local-recursive dnsResolver entries"
  [[ "${none}" -gt 0 ]] || record_failure "${surface}: no none dnsResolver entries"
  [[ "${public_fallback}" -eq 0 ]] || record_failure "${surface}: unauthorized public-fallback dnsResolver entries=${public_fallback}"
  [[ "${access_local}" -gt 0 ]] || record_failure "${surface}: access-dns does not carry local-recursive resolver authority"
  [[ "${non_access_local}" -eq 0 ]] || record_failure "${surface}: non-access mini targets carry local-recursive resolver authority count=${non_access_local}"

  echo "PASS ${trace_id} ${surface} resolver-source artifact counts: local-recursive=${local_recursive} upstream-forwarder=${upstream} dhcp-provided=${dhcp} none=${none} public-fallback=${public_fallback}"
}

check_clab_provider_emulation_inventory() {
  local inventory="/persist/s-router-clab/live-boot/network-artifacts/inventory.json"
  local result

  result="$(ssh_base "${clab_host}" "set -euo pipefail
    test -f '${inventory}'
    jq -r '
      def listify:
        if type == \"array\" then .
        elif type == \"object\" then [.]
        else []
        end;
      (.containerlab // {}) as \$containerlab
      | (\$containerlab.labEmulation.scope // null) as \$scope
      | (
          ((\$containerlab.labEmulation.requests // []) | listify)
          + ((\$containerlab.labEmulation.providerEmulation // []) | listify)
          + ((\$containerlab.providerEmulation // []) | listify)
        ) as \$requests
      | (
          (\$containerlab.capabilities.labEmulation == true)
          or ((\$containerlab.capabilities // []) | type == \"array\" and index(\"lab-emulation\") != null)
          or (\$containerlab.labEmulationCapability == true)
        ) as \$capability
      | (
          any(\$requests[];
            ((.providerEmulationMode // .mode // .kind // .type) == \"fake-provider\")
            and ((.scope // \$scope // \"harness\") == \"harness\")
            and ((.handoffVlan // .providerToCoreHandoff.vlan // null) == 11)
            and ((.liveUpstreamVlan // .liveUpstreamReachability.vlan // null) == 4)
            and (.dhcp4.address == \"10.20.0.1/24\")
            and (.dhcp4.router == \"10.20.0.1\")
            and (.dhcp4.clientAddress == \"10.20.0.20\")
            and (.dhcp4.rangeStart == \"10.20.0.20\")
            and (.dhcp4.rangeEnd == \"10.20.0.99\")
            and (.dhcp4.leaseTime == \"5m\")
            and (.dhcp4.sourcePrefix == \"10.20.0.0/24\")
            and (.nat44.enabled == true)
            and (.nat44.sourcePrefix == \"10.20.0.0/24\")
            and (.defaultRoute? == null)
            and (.defaultFirewall? == null)
          )
        ) as \$requestOk
      | if \$capability and \$requestOk then
          \"OK\"
        else
          \"capability=\" + (\$capability|tostring)
          + \" requestOk=\" + (\$requestOk|tostring)
          + \" requestCount=\" + ((\$requests|length)|tostring)
        end
    ' '${inventory}'
  ")" || {
    record_failure "s-router-clab: cannot inspect deployed CLAB inventory provider-emulation source"
    return
  }

  if [[ "${result}" != "OK" ]]; then
    record_failure "s-router-clab: deployed inventory lacks explicit harness fake-provider emulation for testnet-vlan4 (${result}); expected labEmulation=true with fake-provider handoffVlan=11 liveUpstreamVlan=4 plus explicit DHCPv4 10.20.0.1/24, clientAddress 10.20.0.20, range 10.20.0.20-10.20.0.99, and NAT44 10.20.0.0/24 before recursive DNS route assertions"
    return
  fi

  echo "PASS ${trace_id} s-router-clab deployed inventory declares harness fake-provider emulation: handoffVlan=11 liveUpstreamVlan=4 dhcp4=10.20.0.1/24 clientAddress=10.20.0.20 nat44=10.20.0.0/24"
}

check_clab_fake_provider_runtime() {
  local container="$1"
  local output

  output="$(ssh_base "${clab_host}" "docker exec '${container}' sh -lc '
    set -eu
    ip -4 addr show dev eth1 | grep -F \"10.20.0.1/24\"
    nft list chain ip nat postrouting | grep -F \"ip saddr 10.20.0.0/24 masquerade\"
    ping -c 1 -W 2 1.1.1.1
  '" 2>&1)" || {
    record_failure "s-router-clab ${container}: fake-provider runtime lacks gateway address, NAT44, or upstream IPv4 reachability"
    printf '%s\n' "${output}" >&2
    return
  }

  echo "PASS ${trace_id} s-router-clab ${container} fake-provider runtime has gateway, NAT44, and upstream reachability"
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

check_nixos_resolver_egress() {
  local container="$1"
  local output

  output="$(ssh_base "${nixos_host}" "timeout 10 nixos-container run '${container}' -- sh -lc '
    set -eu
    ip route get 1.1.1.1
  '" 2>&1)" || {
    record_failure "s-router-nixos ${container}: resolver-node has no IPv4 route to upstream egress"
    printf '%s\n' "${output}" >&2
    return
  }

  echo "PASS ${trace_id} s-router-nixos ${container} resolver-node has IPv4 upstream route"
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

check_clab_resolver_egress() {
  local container="$1"
  local output

  output="$(ssh_base "${clab_host}" "docker exec '${container}' sh -lc '
    set -eu
    ip route get 1.1.1.1
  '" 2>&1)" || {
    record_failure "s-router-clab ${container}: resolver-node has no IPv4 route to upstream egress"
    printf '%s\n' "${output}" >&2
    return
  }

  echo "PASS ${trace_id} s-router-clab ${container} resolver-node has IPv4 upstream route"
}

check_clab_upstream_selector_policy_route() {
  local container="$1"
  local output

  output="$(ssh_base "${clab_host}" "docker exec '${container}' sh -lc '
    set -eu
    ip rule show | grep -F \"iif p0 lookup 1001\"
    ip route show table 1001 | grep -F \"default via 10.54.255.6 dev p1\"
    if ip rule show | grep -F \"iif p1 lookup 1001\"; then
      echo \"unexpected resolver-facing p1 rule for runtime-origin default table\" >&2
      exit 43
    fi
    ip route get 1.1.1.1 from 10.54.10.1 iif p0 | grep -F \"dev p1\"
  '" 2>&1)" || {
    record_failure "s-router-clab ${container}: upstream-selector lacks runtime-origin policy default route from p0 to resolver-facing p1"
    printf '%s\n' "${output}" >&2
    return
  }

  echo "PASS ${trace_id} s-router-clab ${container} upstream-selector runtime-origin policy route selects p1"
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

check_current_lab_selection

check_artifact_mini_scope \
  s-router-nixos \
  "${nixos_host}" \
  /etc/network-artifacts/control-plane.json \
  nixos

check_artifact_resolver_sources \
  s-router-nixos \
  "${nixos_host}" \
  /etc/network-artifacts/control-plane.json

check_artifact_mini_scope \
  s-router-clab \
  "${clab_host}" \
  /persist/s-router-clab/live-boot/network-artifacts/control-plane.json \
  clab

check_artifact_resolver_sources \
  s-router-clab \
  "${clab_host}" \
  /persist/s-router-clab/live-boot/network-artifacts/control-plane.json

check_clab_provider_emulation_inventory

nixos_access_container="$(discover_nixos_container access-dns || true)"
nixos_resolver_container="$(discover_nixos_container resolver-node || true)"
clab_access_container="$(discover_clab_container access-dns || true)"
clab_resolver_container="$(discover_clab_container resolver-node || true)"
clab_upstream_container="$(discover_clab_container upstream-selector || true)"
clab_fake_provider_container="$(discover_clab_lab_emulation_container || true)"

[[ -n "${nixos_access_container}" ]] \
  || record_failure "s-router-nixos: live FS-540 mini access-dns container not found"
[[ -n "${nixos_resolver_container}" ]] \
  || record_failure "s-router-nixos: live FS-540 mini resolver-node container not found"
[[ -n "${clab_access_container}" ]] \
  || record_failure "s-router-clab: live FS-540 mini access-dns container not found"
[[ -n "${clab_resolver_container}" ]] \
  || record_failure "s-router-clab: live FS-540 mini resolver-node container not found"
[[ -n "${clab_upstream_container}" ]] \
  || record_failure "s-router-clab: live FS-540 mini upstream-selector container not found"
[[ -n "${clab_fake_provider_container}" ]] \
  || record_failure "s-router-clab: live FS-540 fake-provider lab-emulation container not found"

[[ -z "${clab_fake_provider_container}" ]] || check_clab_fake_provider_runtime "${clab_fake_provider_container}"
[[ -z "${nixos_resolver_container}" ]] || check_nixos_resolver_egress "${nixos_resolver_container}"
[[ -z "${clab_resolver_container}" ]] || check_clab_resolver_egress "${clab_resolver_container}"
[[ -z "${clab_upstream_container}" ]] || check_clab_upstream_selector_policy_route "${clab_upstream_container}"
[[ -z "${nixos_access_container}" ]] || check_nixos_recursive_container "${nixos_access_container}"
[[ -z "${clab_access_container}" ]] || check_clab_recursive_container "${clab_access_container}"
[[ -z "${clab_resolver_container}" ]] || check_clab_no_docker_host_resolver_fallback "${clab_resolver_container}"

if [[ "${failures}" -ne 0 ]]; then
  echo "FAIL ${trace_id}: live recursive DNS SIT failed with ${failures} finding(s)" >&2
  exit 1
fi

echo "PASS ${trace_id} live recursive DNS SIT"
