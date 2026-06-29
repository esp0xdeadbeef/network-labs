#!/usr/bin/env bash
# GAMP-SCOPE: focused live SIT probe for active-lab PPPoE runtime; not a HAT runner
set -euo pipefail

trace_id="${1:?trace id required}"
row_role="${2:?row role required}"
nixos_host="${S_ROUTER_NIXOS:-s-router-nixos}"
clab_host="${S_ROUTER_CLAB:-s-router-clab}"
failures=0

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

check_control_plane() {
  local surface="$1"
  local host="$2"
  local control_path="$3"
  local prefix="$4"
  local counts targets providers clients servers pppoe_clients

  counts="$(ssh_base "${host}" "set -euo pipefail
    test -f '${control_path}'
    jq -r \
      --arg target_re '(^|-)${prefix}-(provider-handoff-access-[ab]|core-testnet-(host|routed)-isp)$' \
      --arg provider_re '(^|-)${prefix}-provider-handoff-access-[ab]$' \
      --arg client_re '(^|-)${prefix}-core-testnet-(host|routed)-isp$' \
      '
        def rts:
          .control_plane_model.data[][]?.runtimeTargets? // {} | to_entries[];
        [
          ([rts | select(.key | test(\$target_re))] | length),
          ([rts | select(.key | test(\$provider_re))] | length),
          ([rts | select(.key | test(\$client_re))] | length),
          ([rts | select(.key | test(\$provider_re)) | select((.value.services.pppoe.server? // null) != null)] | length),
          ([rts | select(.key | test(\$client_re)) | select((.value.services.pppoe.client? // null) != null)] | length)
        ] | @tsv
      ' '${control_path}'
  ")" || {
    record_failure "${surface}: cannot inspect ${control_path}"
    return
  }

  read -r targets providers clients servers pppoe_clients <<<"${counts}"

  [[ "${targets}" -ge 4 ]] \
    || record_failure "${surface}: expected >=4 PPPoE provider/customer targets, got ${targets}"
  [[ "${providers}" -ge 2 ]] \
    || record_failure "${surface}: expected >=2 provider targets, got ${providers}"
  [[ "${clients}" -ge 2 ]] \
    || record_failure "${surface}: expected >=2 customer/client targets, got ${clients}"
  [[ "${servers}" -ge 2 ]] \
    || record_failure "${surface}: expected >=2 provider-side PPPoE server records, got ${servers}"
  [[ "${pppoe_clients}" -ge 2 ]] \
    || record_failure "${surface}: expected >=2 customer-side PPPoE client records, got ${pppoe_clients}"

  echo "PASS ${trace_id} ${surface} control-plane records: targets=${targets} providers=${providers} clients=${clients} pppoe_servers=${servers} pppoe_clients=${pppoe_clients}"
}

check_nixos_provider_runtime() {
  local container active proc
  for container in nixos-provider-handoff-access-a nixos-provider-handoff-access-b; do
    active="$(ssh_base "${nixos_host}" "machinectl shell root@${container} /run/current-system/sw/bin/systemctl show s88-pppoe-server.service -p ActiveState --value 2>/dev/null | tr -d '\r' | awk '/^(active|inactive|failed|activating|deactivating|unknown)\$/ {print; exit}'" || true)"
    if [[ "${active}" != "active" ]]; then
      record_failure "s-router-nixos ${container}: s88-pppoe-server.service is not active"
    fi
    proc="$(ssh_base "${nixos_host}" "machinectl shell root@${container} /run/current-system/sw/bin/sh -lc \"ps -ef | grep -E '[p]ppoe-server' || true\"" || true)"
    if ! grep -F "pppoe-server" <<<"${proc}" >/dev/null; then
      record_failure "s-router-nixos ${container}: pppoe-server process is not running"
    fi
  done
}

check_nixos_customer_runtime() {
  local container unit active proc
  for container in nixos-core-testnet-host-isp nixos-core-testnet-routed-isp; do
    unit="$(ssh_base "${nixos_host}" "machinectl shell root@${container} /run/current-system/sw/bin/systemctl --no-pager --plain --full list-unit-files 'pppd-s88*' 2>/dev/null | tr -d '\r' | awk '/^pppd-s88/ {print \$1; exit}'" || true)"
    if [[ -z "${unit}" ]]; then
      record_failure "s-router-nixos ${container}: no pppd-s88 PPPoE client unit file"
      continue
    fi
    active="$(ssh_base "${nixos_host}" "machinectl shell root@${container} /run/current-system/sw/bin/systemctl show '${unit}' -p ActiveState --value 2>/dev/null | tr -d '\r' | awk '/^(active|inactive|failed|activating|deactivating|unknown)\$/ {print; exit}'" || true)"
    if [[ "${active}" != "active" ]]; then
      record_failure "s-router-nixos ${container}: ${unit} is ${active:-not-reporting-active}"
    fi
    proc="$(ssh_base "${nixos_host}" "machinectl shell root@${container} /run/current-system/sw/bin/sh -lc \"ps -ef | grep -E '[p]ppd .*s88-pppoe-client|[p]ppoe -I' || true\"" || true)"
    if ! grep -E 'pppd .*s88-pppoe-client|pppoe -I' <<<"${proc}" >/dev/null; then
      record_failure "s-router-nixos ${container}: pppd/pppoe client process is not running"
    fi
  done
}

check_clab_provider_runtime() {
  local container
  for container in \
    clab-fabric-esp0xdeadbeef-site-b-clab-provider-handoff-access-a \
    clab-fabric-esp0xdeadbeef-site-b-clab-provider-handoff-access-b
  do
    if ! ssh_base "${clab_host}" "docker exec ${container} sh -lc \"ip -o link show ppp0 >/dev/null && ps -ef | grep -E '[p]ppoe-server|[p]ppd pty' >/dev/null\""; then
      record_failure "s-router-clab ${container}: provider PPPoE server/session process is not running"
    fi
  done
}

check_clab_customer_runtime() {
  local container iface
  for entry in \
    clab-fabric-esp0xdeadbeef-site-b-clab-core-testnet-host-isp:ppp0 \
    clab-fabric-esp0xdeadbeef-site-b-clab-core-testnet-routed-isp:ppp1
  do
    container="${entry%%:*}"
    iface="${entry##*:}"
    if ! ssh_base "${clab_host}" "docker exec ${container} sh -lc \"ip -o link show ${iface} >/dev/null && ps -ef | grep -E '[p]ppd pty pppoe -I|[p]ppoe -I' >/dev/null\""; then
      record_failure "s-router-clab ${container}: customer PPPoE client ${iface} is not active"
    fi
  done
}

check_control_plane \
  s-router-nixos \
  "${nixos_host}" \
  /etc/network-artifacts/control-plane.json \
  nixos

check_control_plane \
  s-router-clab \
  "${clab_host}" \
  /persist/s-router-clab/live-boot/network-artifacts/control-plane.json \
  clab

case "${row_role}" in
  provider-side)
    check_nixos_provider_runtime
    check_clab_provider_runtime
    ;;
  customer-side)
    check_nixos_customer_runtime
    check_clab_customer_runtime
    ;;
  *)
    record_failure "unknown row role ${row_role}"
    ;;
esac

if [[ "${failures}" -ne 0 ]]; then
  echo "FAIL ${trace_id}: live active-lab PPPoE ${row_role} runtime failed with ${failures} finding(s)" >&2
  exit 1
fi

echo "PASS ${trace_id} live active-lab PPPoE ${row_role} runtime"
