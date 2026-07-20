#!/usr/bin/env bash
set -euo pipefail

trace_id="${SMS_TEST_TRACE_ID:-${1:-}}"
[[ "${trace_id}" == FS-166-HDS-010-SDS-010-SMS-90[1-6] ]] || {
  printf 'usage: %s FS-166-HDS-010-SDS-010-SMS-90[1-6]\n' "$0" >&2
  exit 64
}
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

result="$(nix run .#validation-scheme -- --scenario "$trace_id")"
jq -e --arg traceId "$trace_id" '
  .manifest.traceId == $traceId
  and .scenarioManifest.kind == "replacement-cpm-artifact"
  and .scenarioManifest.declaredFirstActiveBoundary == "network-realization-model"
  and .evidence.status == "construction-ok"
  and .artifactFlow.realization.bundleIdentity == .artifactFlow.renderer.bundleIdentity
  and .artifactFlow.platformBinding.bindingIdentity == .artifactFlow.renderer.bindingIdentity
' <<<"$result" >/dev/null

printf 'PASS %s: controlled replacement, realization, schema, binding, and canonical renderer input\n' "$trace_id"
