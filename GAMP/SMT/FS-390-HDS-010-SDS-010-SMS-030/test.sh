#!/usr/bin/env bash
# GAMP-ID: FS-390-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: active-lab mini SMT source and NFM broad-WAN public IPv4 denial check
set -euo pipefail

trace_id="FS-390-HDS-010-SDS-010-SMS-030"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
row_root="${repo_root}/GAMP/SMT/${trace_id}"
nfm_root="${NETWORK_FORWARDING_MODEL_ROOT:-${repo_root}/../network-forwarding-model}"
tmp_dir="$(mktemp -d "/tmp/${trace_id}.XXXXXX")"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

[[ -f "${row_root}/intent.nix" ]] || fail "missing row intent"
[[ -d "${nfm_root}" ]] || fail "missing network-forwarding-model root: ${nfm_root}"

nix eval --impure --expr "
let
  row = import ${row_root}/default.nix;
  intent = import ${row_root}/intent.nix;
  site = intent.\"mini-smt\".\"${trace_id}\";
  require = cond: msg: if cond then true else throw msg;
  expectedRelations = [
    \"${trace_id}__mini-verify\"
    \"${trace_id}__client-to-tenant-service-public-via-broad-wan\"
    \"${trace_id}__client-to-public-ingress-via-broad-wan\"
  ];
  relationIds = map (relation: relation.id) site.communicationContract.relations;
  allowedRelationIds = map (relation: relation.id) site.communicationContract.allowedRelations;
  targetKinds = map (relation: relation.to.kind or \"missing\") site.communicationContract.relations;
in
  require (row.traceId == \"${trace_id}\")
    \"row default must carry full trace id\"
  && require (row.source.kind == \"intent-source\")
    \"row must be an intent-source mini SMT\"
  && require (row.source.expectedRelationIds == expectedRelations)
    \"row default must list every full-trace relation id\"
  && require (relationIds == expectedRelations && allowedRelationIds == expectedRelations)
    \"intent must carry every allow relation in relations and allowedRelations\"
  && require (targetKinds == [ \"external\" \"public-ipv4\" \"public-ipv4\" ])
    \"intent must model public IPv4 destinations as compiler-owned targets\"
  && require (!(site ? trafficPaths))
    \"intent-source row must not hand-code compiler-derived trafficPaths\"
" >/dev/null || fail "intent source predicates failed"

ln -s "${repo_root}/GAMP" "${tmp_dir}/GAMP"
NETWORK_LABS_CURRENT_LAB_DIR="${tmp_dir}/current-lab" \
NETWORK_FORWARDING_MODEL_ROOT="${nfm_root}" \
  bash "${repo_root}/scripts/select-current-lab.sh" SMT "${trace_id}" >/dev/null

nix run --show-trace --no-warn-dirty --no-write-lock-file \
  "path:${nfm_root}#compile-and-build-forwarding-model" -- \
  "${tmp_dir}/current-lab/intent.nix" \
  >"${tmp_dir}/forwarding.json"

jq -e --arg trace "${trace_id}" '
  .enterprise."mini-smt".site[$trace].publicIpv4DestinationPolicy as $policy
  | ([ $policy.broadWanDenials[]
      | select(.relationId == ($trace + "__client-to-tenant-service-public-via-broad-wan"))
      | select(.destinationAddress == "203.0.113.100")
      | select(.destinationClass == "tenant-service")
      | select(.reason == "broad-wan-does-not-authorize-model-owned-public-ipv4")
      | select(.allowed == false)
    ] | length == 1)
    and ([ $policy.broadWanDenials[]
      | select(.relationId == ($trace + "__client-to-public-ingress-via-broad-wan"))
      | select(.destinationAddress == "198.51.100.34")
      | select(.destinationClass == "public-ingress")
      | select(.reason == "broad-wan-does-not-authorize-model-owned-public-ipv4")
      | select(.allowed == false)
    ] | length == 1)
    and ([ $policy.diagnostics[]
      | select(.relationId == ($trace + "__client-to-tenant-service-public-via-broad-wan"))
      | select(.destinationAddress == "203.0.113.100")
    ] | length == 1)
    and ([ $policy.diagnostics[]
      | select(.relationId == ($trace + "__client-to-public-ingress-via-broad-wan"))
      | select(.destinationAddress == "198.51.100.34")
    ] | length == 1)
    and (($policy.shortcutAuthorizations // {}) == {})
' "${tmp_dir}/forwarding.json" >/dev/null || {
  jq '.enterprise."mini-smt".site[$trace].publicIpv4DestinationPolicy' \
    --arg trace "${trace_id}" \
    "${tmp_dir}/forwarding.json" >&2
  fail "forwarding broad-WAN denial predicates failed"
}

echo "PASS ${trace_id}: source fixture and broad WAN public IPv4 denial"
