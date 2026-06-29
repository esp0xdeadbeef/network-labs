#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-020-SMS-040
# GAMP-SCOPE: focused live SIT probe for provider-handoff PPPoE default-route behavior; not a HAT runner
set -euo pipefail

trace_id="FS-800-HDS-010-SDS-020-SMS-040"
nixos_host="${S_ROUTER_NIXOS:-s-router-nixos}"
clab_host="${S_ROUTER_CLAB:-s-router-clab}"
failures=0

record_failure() {
  echo "FAIL ${trace_id}: $*" >&2
  failures=$((failures + 1))
}

ssh_base() {
  local host="$1"
  local command="$2"
  ssh -n \
    -o BatchMode=yes \
    -o ConnectTimeout=5 \
    -o StrictHostKeyChecking=accept-new \
    "root@${host}" \
    "${command}"
}

shell_quote() {
  printf "'"
  printf '%s' "$1" | sed "s/'/'\\\\''/g"
  printf "'"
}

probe_payload() {
  local address="$1"
  printf 'ip -color=never -o -4 addr show dev ppp0; '
  printf 'ip -color=never route show default || true; '
  printf 'ip -color=never route get 1.1.1.1 from %s' "${address}"
}

validate_provider_route() {
  local surface="$1"
  local container="$2"
  local address="$3"
  local output="$4"
  local default_route route

  if ! grep -F "ppp0" <<<"${output}" >/dev/null || ! grep -F "${address}" <<<"${output}" >/dev/null; then
    record_failure "${surface} ${container}: ppp0 with ${address} is not present"
    printf '%s\n' "${output}" >&2
    return 1
  fi

  default_route="$(grep -E '^default ' <<<"${output}" | tail -n 1 || true)"
  route="$(grep -E '^1\.1\.1\.1 ' <<<"${output}" | tail -n 1 || true)"
  if [[ "${default_route}" != *" dev ppp0"* ]]; then
    record_failure "${surface} ${container}: default route is not PPPoE-backed"
    printf '%s\n' "${output}" >&2
    return 1
  fi
  if [[ "${route}" != *" dev ppp0"* || "${route}" == *" dev ens"* ]]; then
    record_failure "${surface} ${container}: public route from ${address} is not PPPoE-backed"
    printf '%s\n' "${output}" >&2
    return 1
  fi

  printf 'PASS %s %s %s provider-handoff default route uses PPPoE\n%s\n' \
    "${trace_id}" "${surface}" "${container}" "${output}"
}

check_nixos_provider() {
  local container="$1"
  local address="$2"
  local output quoted_probe
  quoted_probe="$(shell_quote "$(probe_payload "${address}")")"
  if ! output="$(ssh_base "${nixos_host}" \
    "machinectl shell root@${container} /run/current-system/sw/bin/sh -lc ${quoted_probe}" 2>&1)"; then
    record_failure "s-router-nixos ${container}: provider-handoff default route is not PPPoE-backed"
    printf '%s\n' "${output}" >&2
    return
  fi
  validate_provider_route "s-router-nixos" "${container}" "${address}" "${output}" || true
}

check_clab_provider() {
  local container="$1"
  local address="$2"
  local output quoted_probe
  quoted_probe="$(shell_quote "$(probe_payload "${address}")")"
  if ! output="$(ssh_base "${clab_host}" \
    "docker exec ${container} sh -lc ${quoted_probe}" 2>&1)"; then
    record_failure "s-router-clab ${container}: provider-handoff default route is not PPPoE-backed"
    printf '%s\n' "${output}" >&2
    return
  fi
  validate_provider_route "s-router-clab" "${container}" "${address}" "${output}" || true
}

check_nixos_provider nixos-provider-handoff-access-a 203.0.113.5
check_nixos_provider nixos-provider-handoff-access-b 203.0.113.1

check_clab_provider clab-fabric-esp0xdeadbeef-site-b-clab-provider-handoff-access-a 203.0.113.5
check_clab_provider clab-fabric-esp0xdeadbeef-site-b-clab-provider-handoff-access-b 203.0.113.1

if [[ "${failures}" -ne 0 ]]; then
  echo "FAIL ${trace_id}: live active-lab provider-handoff PPPoE default-route SIT failed with ${failures} finding(s)" >&2
  exit 1
fi

echo "PASS ${trace_id} live active-lab provider-handoff PPPoE default-route SIT"
