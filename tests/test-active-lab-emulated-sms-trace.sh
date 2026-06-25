#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-900
# GAMP-SCOPE: active-lab runtime entry marker; not HAT/SAT approval evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-166-HDS-010-SDS-010-SMS-900__allow-client-to-testnet-host-isp"
original_id="allow-client-to-testnet-host-isp"

fail() {
  echo "FAIL active-lab-emulated-sms-trace: $*" >&2
  exit 1
}

nix eval --impure --expr "
  let
    intent = import ${repo_root}/active-lab/intent.nix;
    require = cond: msg: if cond then true else throw msg;
    collectIds =
      value:
      if builtins.isAttrs value then
        (if value ? id then [ value.id ] else [ ])
        ++ builtins.concatLists (map collectIds (builtins.attrValues value))
      else if builtins.isList value then
        builtins.concatLists (map collectIds value)
      else
        [ ];
    ids = collectIds intent;
    count = needle:
      builtins.length (builtins.filter (value: value == needle) ids);
  in
    require (count \"${trace_id}\" >= 1)
      \"active-lab intent must expose the emulated FS/HDS/SDS/SMS relation ID\"
    && require (count \"${original_id}\" == 0)
      \"active-lab intent must not leave the original relation ID alongside the emulated trace marker\"
" >/dev/null || fail "active-lab intent did not expose ${trace_id}"

echo "PASS active-lab-emulated-sms-trace"
