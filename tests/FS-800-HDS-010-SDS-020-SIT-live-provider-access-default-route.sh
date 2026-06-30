#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-020-SMS-040
# GAMP-SCOPE: focused live SIT probe for the row-local current-lab provider-handoff default route; not a HAT runner
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

validate_provider_route() {
  local surface="$1"
  local container="$2"
  local address="$3"
  local expected_gateway="$4"
  local output="$5"
  local default_route route default_dev route_dev

  if ! grep -F "${address}" <<<"${output}" >/dev/null; then
    record_failure "${surface} ${container}: provider-handoff address ${address} is not present"
    printf '%s\n' "${output}" >&2
    return 1
  fi

  default_route="$(grep -E '^default ' <<<"${output}" | tail -n 1 || true)"
  route="$(grep -E '^1\.1\.1\.1 ' <<<"${output}" | tail -n 1 || true)"
  default_dev="$(sed -n 's/.* dev \([^ ]*\).*/\1/p' <<<"${default_route}")"
  route_dev="$(sed -n 's/.* dev \([^ ]*\).*/\1/p' <<<"${route}")"

  if [[ -z "${default_route}" || -z "${route}" ]]; then
    record_failure "${surface} ${container}: missing default route or public route-get output"
    printf '%s\n' "${output}" >&2
    return 1
  fi

  if grep -E '(^[0-9]+: ppp| dev ppp| ppp0)' <<<"${output}" >/dev/null; then
    record_failure "${surface} ${container}: provider-handoff route leaked onto a PPP interface"
    printf '%s\n' "${output}" >&2
    return 1
  fi

  if [[ "${default_route}" != *" via ${expected_gateway} "* || "${route}" != *" via ${expected_gateway} "* ]]; then
    record_failure "${surface} ${container}: provider-handoff route does not use expected downstream-selector gateway ${expected_gateway}"
    printf '%s\n' "${output}" >&2
    return 1
  fi

  if [[ -z "${default_dev}" || "${default_dev}" != "${route_dev}" ]]; then
    record_failure "${surface} ${container}: default and route-get use different or missing fabric devices"
    printf '%s\n' "${output}" >&2
    return 1
  fi

  printf 'PASS %s %s %s provider-handoff default route uses fabric gateway %s on %s with provider address %s and no PPP leak\n%s\n' \
    "${trace_id}" "${surface}" "${container}" "${expected_gateway}" "${default_dev}" "${address}" "${output}"
}

probe_payload() {
  printf 'ip -color=never -o -4 addr; '
  printf 'ip -color=never route show; '
  printf 'ip -color=never route get 1.1.1.1 || true'
}

validate_pppoe_core_route() {
  local surface="$1"
  local container="$2"
  local output="$3"

  if ! grep -E '^default .* dev u0' <<<"${output}" >/dev/null; then
    record_failure "${surface} ${container}: PPPoE-side core default route is not isolated on uplink u0"
    printf '%s\n' "${output}" >&2
    return 1
  fi

  if grep -E '^default .* dev p0' <<<"${output}" >/dev/null; then
    record_failure "${surface} ${container}: PPPoE-side core default route leaked onto fabric p0"
    printf '%s\n' "${output}" >&2
    return 1
  fi

  printf 'PASS %s %s %s PPPoE-side core default route stays on uplink u0\n%s\n' \
    "${trace_id}" "${surface}" "${container}" "${output}"
}

pppoe_core_probe_payload() {
  printf 'ip -color=never -o -4 addr; '
  printf 'ip -color=never route show'
}

check_nixos_pppoe_core() {
  local container="$1"
  local output quoted_probe
  quoted_probe="$(shell_quote "$(pppoe_core_probe_payload)")"
  if ! output="$(ssh_base "${nixos_host}" \
    "machinectl shell root@${container} /run/current-system/sw/bin/sh -lc ${quoted_probe}" 2>&1)"; then
    record_failure "s-router-nixos ${container}: PPPoE-side core route probe failed"
    printf '%s\n' "${output}" >&2
    return
  fi
  validate_pppoe_core_route "s-router-nixos" "${container}" "${output}" || true
}

check_clab_pppoe_core() {
  local container="$1"
  local output quoted_probe
  quoted_probe="$(shell_quote "$(pppoe_core_probe_payload)")"
  if ! output="$(ssh_base "${clab_host}" \
    "docker exec ${container} sh -lc ${quoted_probe}" 2>&1)"; then
    record_failure "s-router-clab ${container}: PPPoE-side core route probe failed"
    printf '%s\n' "${output}" >&2
    return
  fi
  validate_pppoe_core_route "s-router-clab" "${container}" "${output}" || true
}

check_nixos_provider() {
  local container="$1"
  local address="$2"
  local expected_gateway="$3"
  local output quoted_probe
  quoted_probe="$(shell_quote "$(probe_payload)")"
  if ! output="$(ssh_base "${nixos_host}" \
    "machinectl shell root@${container} /run/current-system/sw/bin/sh -lc ${quoted_probe}" 2>&1)"; then
    record_failure "s-router-nixos ${container}: provider-handoff fabric route probe failed"
    printf '%s\n' "${output}" >&2
    return
  fi
  validate_provider_route "s-router-nixos" "${container}" "${address}" "${expected_gateway}" "${output}" || true
}

check_clab_provider() {
  local container="$1"
  local address="$2"
  local expected_gateway="$3"
  local output quoted_probe
  quoted_probe="$(shell_quote "$(probe_payload)")"
  if ! output="$(ssh_base "${clab_host}" \
    "docker exec ${container} sh -lc ${quoted_probe}" 2>&1)"; then
    record_failure "s-router-clab ${container}: provider-handoff fabric route probe failed"
    printf '%s\n' "${output}" >&2
    return
  fi
  validate_provider_route "s-router-clab" "${container}" "${address}" "${expected_gateway}" "${output}" || true
}

check_nixos_provider provider-handoff-access-a 203.0.113.1 10.80.255.2
check_nixos_pppoe_core pppoe-core

check_clab_provider clab-fabric-mini-smt-provider-access-default-route-provider-handoff-access-a 203.0.113.1 10.80.255.2
check_clab_pppoe_core clab-fabric-mini-smt-provider-access-default-route-pppoe-core

if [[ "${failures}" -ne 0 ]]; then
  echo "FAIL ${trace_id}: live active-lab provider-handoff fabric default-route SIT failed with ${failures} finding(s)" >&2
  exit 1
fi

echo "PASS ${trace_id} live active-lab provider-handoff fabric default-route SIT"
