#!/usr/bin/env bash
# GAMP-ID: FS-162-HDS-010-SDS-040-SMS-010
# GAMP-SCOPE: construction-only peer-renderer proof
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
github_root="$(dirname "${repo_root}")"
renderer="${NETWORK_RENDERER_OPENCONFIG_PATH:-${github_root}/network-renderer-openconfig}"

renderer_revision="9cff098bc2b9d6f9ae28ea5846eb7d128f530a2b"
labs_revision="151c35105453ad17f354bf3832753306ba32164a"
cpm_revision="0684468ba9824e01545a22f526bc2c79c294ac7f"
compiler_revision="6dea1cd4315da82036fa46b68382586c9c01eda0"

fail() {
  printf 'FAIL FS-162-HDS-010-SDS-040-SMS-010: %s\n' "$*" >&2
  exit 1
}

[[ -d "${renderer}/.git" || -f "${renderer}/.git" ]] \
  || fail "network-renderer-openconfig checkout is missing: ${renderer}"
[[ "$(git -C "${renderer}" branch --show-current)" == "main" ]] \
  || fail "network-renderer-openconfig is not on main"
[[ "$(git -C "${renderer}" rev-parse HEAD)" == "$(git -C "${renderer}" rev-parse origin/main)" ]] \
  || fail "network-renderer-openconfig HEAD does not match origin/main"
[[ -z "$(git -C "${renderer}" status --porcelain=v1 --untracked-files=all)" ]] \
  || fail "network-renderer-openconfig checkout is dirty"
git -C "${renderer}" merge-base --is-ancestor "${renderer_revision}" HEAD \
  || fail "pushed OpenConfig posture implementation is absent from main"

lock="${renderer}/flake.lock"
locked_labs="$(jq -r '.nodes.root.inputs["network-labs"] as $node | .nodes[$node].locked.rev' "${lock}")"
locked_cpm="$(jq -r '.nodes.root.inputs["network-control-plane-model"] as $node | .nodes[$node].locked.rev' "${lock}")"
locked_compiler="$(jq -r '
  .nodes.root.inputs["network-control-plane-model"] as $cpm
  | .nodes[$cpm].inputs["network-forwarding-model"] as $nfm
  | .nodes[$nfm].inputs["network-compiler"] as $compiler
  | .nodes[$compiler].locked.rev
' "${lock}")"

[[ "${locked_labs}" == "${labs_revision}" ]] \
  || fail "OpenConfig renderer does not pin the controlled FS-230 construction source"
[[ "${locked_cpm}" == "${cpm_revision}" ]] \
  || fail "OpenConfig renderer does not pin the controlled CPM revision"
[[ "${locked_compiler}" == "${compiler_revision}" ]] \
  || fail "OpenConfig renderer does not pin the controlled compiler revision"

bash "${renderer}/tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh"

printf '%s\n' 'PASS FS-162-HDS-010-SDS-040-SMS-010 OpenConfig consumes direct CPM input with the same normalized FS-230 posture'
