#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-020-SDS-021
# GAMP-SCOPE: focused live SIT probe for active-lab PPPoE secret exposure; not a HAT runner
set -euo pipefail

host="${1:-s-router-nixos}"
trace_id="FS-800-HDS-020-SDS-021"

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

ssh_base=(
  ssh -n
  -o BatchMode=yes
  -o ConnectTimeout=5
  -o StrictHostKeyChecking=accept-new
  "root@${host}"
)

"${ssh_base[@]}" 'true' >/dev/null 2>&1 \
  || fail "cannot SSH to ${host}"

"${ssh_base[@]}" 'set -euo pipefail
  for secret in /run/secrets/hat-pppoe-username /run/secrets/hat-pppoe-password; do
    test -f "${secret}" || {
      echo "missing ${secret}" >&2
      exit 10
    }
    mode="$(stat -c "%a %U %G" "${secret}")"
    test "${mode}" = "400 root root" || {
      echo "bad boundary ${secret}: ${mode}" >&2
      exit 11
    }
  done

  for unit in \
    container@nixos-core-testnet-host-isp.service \
    container@nixos-core-testnet-routed-isp.service \
    container@nixos-provider-handoff-access-a.service \
    container@nixos-provider-handoff-access-b.service
  do
    if journalctl -u "${unit}" -n 160 --no-pager 2>/dev/null \
      | grep -F "Failed to clone /run/secrets/hat-pppoe-password" >/dev/null
    then
      echo "${unit} still fails to clone /run/secrets/hat-pppoe-password" >&2
      exit 12
    fi
  done
' || fail "${host} active-lab PPPoE SOPS secret exposure is not materialized"

echo "PASS ${trace_id} live secret presence on ${host}"
