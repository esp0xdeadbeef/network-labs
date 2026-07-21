#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-030-SDS-010-SMS-041
# GAMP-SCOPE: focused live SIT probe for active-lab CLAB renderer status; not a HAT runner
set -euo pipefail

host="${1:-s-router-clab}"
trace_id="FS-720-HDS-030-SDS-010-SMS-041"
status_path="/persist/s-router-clab/live-boot/s-router-clab-render-live-status.json"

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

"${ssh_base[@]}" "set -euo pipefail
  test -f '${status_path}' || {
    echo 'missing ${status_path}' >&2
    exit 20
  }
  jq -e '
    .serviceName == \"s-router-clab-render-live\"
    and .phase == \"complete\"
    and .result == \"success\"
    and (.topology | type == \"string\" and length > 0)
  ' '${status_path}' >/dev/null || {
    cat '${status_path}' >&2
    exit 21
  }

  if journalctl -u s-router-clab-render-live.service -n 220 --no-pager 2>/dev/null \
    | grep -F \"multiple bridge network definitions render to 'br-wan'\" >/dev/null
  then
    echo \"live renderer still fails duplicate br-wan target-host bridge scoping\" >&2
    exit 22
  fi

  if systemctl is-failed --quiet s-router-clab-render-live.service; then
    systemctl status --no-pager -l s-router-clab-render-live.service >&2 || true
    exit 23
  fi
" || fail "${host} CLAB render-live status is not a successful locked artifact"

echo "PASS ${trace_id} live CLAB render status on ${host}"
