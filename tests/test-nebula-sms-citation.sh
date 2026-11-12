#!/usr/bin/env bash
# GAMP-SCOPE: cross-repo construction check — a renderer throw must cite a
# controlled SMS id that exists. Not HAT/SAT evidence.
#
# network-renderer-nebula raises provider-contract errors citing
# FS-310-HDS-010-SDS-010-SMS-110. That id does not exist in the controlled tree,
# so the throw names no authority a reader can consult, and the requirement it
# enforces (service.listenHost) is invisible to the layer that must satisfy it.
#
# This case asserts the citation is resolvable. The fix belongs in
# network-renderer-nebula (cite the real SMS id) or in the controlled tree (add
# the missing row); this repository only proves the gap.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
workspace_root="${NETWORK_WORKSPACE_ROOT:-$(cd "${repo_root}/.." && pwd)}"
canonical_sms="${CANONICAL_SMS_DIR:-${workspace_root}/network-codex-agent/GAMP/SMS}"
nebula="${NETWORK_RENDERER_NEBULA_PATH:-${workspace_root}/network-renderer-nebula}"
cited_id="FS-310-HDS-010-SDS-010-SMS-110"

fail() { echo "FAIL nebula-sms-citation: $*" >&2; exit 1; }

[[ -d "${nebula}" ]] || fail "network-renderer-nebula not found at ${nebula}"
[[ -d "${canonical_sms}" ]] || fail "canonical SMS tree not found at ${canonical_sms}"

# Every FS id the renderer cites as an authority.
mapfile -t cited < <(
  grep -rhoE 'FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+' "${nebula}" --include=*.nix 2>/dev/null \
    | LC_ALL=C sort -u
)
((${#cited[@]} > 0)) || fail "renderer cites no SMS ids; the check would assert nothing"

missing=()
for id in "${cited[@]}"; do
  if [[ ! -f "${canonical_sms}/${id}.md" ]] && [[ ! -d "${repo_root}/GAMP/SMS/${id}" ]]; then
    missing+=("${id}")
  fi
done

if ((${#missing[@]} > 0)); then
  for id in "${missing[@]}"; do
    echo "  cited but not in the controlled tree: ${id}" >&2
  done
  fail "${#missing[@]} SMS id(s) cited by network-renderer-nebula do not exist; ${cited_id} guards service.listenHost, which no layer is told to emit"
fi

echo "PASS nebula-sms-citation: every SMS id cited by network-renderer-nebula resolves"
