#!/usr/bin/env bash
# GAMP-ID: FS-390-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: active-lab mini SMT source and NFM shortcut-policy check
set -euo pipefail

trace_id="FS-390-HDS-010-SDS-010-SMS-020"
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
    \"${trace_id}__client-to-tenant-api\"
    \"${trace_id}__testnet-to-public-web\"
  ];
  relationIds = map (relation: relation.id) site.communicationContract.relations;
  allowedRelationIds = map (relation: relation.id) site.communicationContract.allowedRelations;
  serviceByName = name:
    let matches = builtins.filter (service: service.name == name) site.communicationContract.services;
    in if builtins.length matches == 1 then builtins.head matches else throw (\"missing service \" + name);
  tenantApi = serviceByName \"tenant-api\";
  publicWeb = serviceByName \"public-web\";
in
  require (row.traceId == \"${trace_id}\")
    \"row default must carry full trace id\"
  && require (row.source.kind == \"intent-source\")
    \"row must be an intent-source mini SMT\"
  && require (row.source.expectedRelationIds == expectedRelations)
    \"row default must list every full-trace relation id\"
  && require (relationIds == expectedRelations && allowedRelationIds == expectedRelations)
    \"intent must carry every allow relation in relations and allowedRelations\"
  && require (tenantApi.publicIpv4 == \"198.51.100.21/32\")
    \"tenant-api must expose modeled public IPv4\"
  && require (publicWeb.publicIngress.enabled == true && publicWeb.publicIngress.ipv4 == \"198.51.100.24/32\")
    \"public-web must be modeled as public ingress\"
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
  | $policy.destinationClasses["public-ipv4-destination::198.51.100.21"] as $tenantService
  | $policy.destinationClasses["public-ipv4-destination::198.51.100.24"] as $publicIngress
  | ([ $policy.shortcutAuthorizations[]
      | select(.relationId == ($trace + "__client-to-tenant-api"))
      | select(.destinationAddress == "198.51.100.21")
      | select(.destinationClass == "tenant-service")
      | select(.returnBehavior == "symmetric")
      | select(.allowed == true)
    ] | length == 1)
    and ([ $policy.shortcutAuthorizations[]
      | select(.relationId == ($trace + "__testnet-to-public-web"))
      | select(.destinationAddress == "198.51.100.24")
      | select(.destinationClass == "public-ingress")
      | select(.returnBehavior == "symmetric")
      | select(.allowed == true)
    ] | length == 1)
    and ($tenantService.destinationClass == "tenant-service")
    and ($tenantService.ownerName == "tenant-api")
    and ($publicIngress.destinationClass == "public-ingress")
    and ($publicIngress.ownerName == "public-web")
    and (($policy.shortcutPolicyDenials // {}) == {})
' "${tmp_dir}/forwarding.json" >/dev/null || {
  jq '.enterprise."mini-smt".site[$trace].publicIpv4DestinationPolicy' \
    --arg trace "${trace_id}" \
    "${tmp_dir}/forwarding.json" >&2
  fail "forwarding shortcut policy predicates failed"
}

echo "PASS ${trace_id}: source fixture and public IPv4 shortcut policy"
