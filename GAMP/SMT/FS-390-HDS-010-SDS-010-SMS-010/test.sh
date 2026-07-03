#!/usr/bin/env bash
# GAMP-ID: FS-390-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: active-lab mini SMT source and NFM construction check
set -euo pipefail

trace_id="FS-390-HDS-010-SDS-010-SMS-010"
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
    \"${trace_id}__client-to-fixture-missing-output\"
    \"${trace_id}__testnet-to-public-web\"
  ];
  relationIds = map (relation: relation.id) site.communicationContract.relations;
  allowedRelationIds = map (relation: relation.id) site.communicationContract.allowedRelations;
  serviceByName = name:
    let matches = builtins.filter (service: service.name == name) site.communicationContract.services;
    in if builtins.length matches == 1 then builtins.head matches else throw (\"missing service \" + name);
  tenantApi = serviceByName \"tenant-api\";
  missingOutput = serviceByName \"fixture-missing-output\";
  publicWeb = serviceByName \"public-web\";
  endpointNames = map (endpoint: endpoint.name) site.ownership.endpoints;
in
  require (row.traceId == \"${trace_id}\")
    \"row default must carry full trace id\"
  && require (row.source.kind == \"intent-source\")
    \"row must be an intent-source mini SMT\"
  && require (row.source.expectedRelationIds == expectedRelations)
    \"row default must list every full-trace relation id\"
  && require (relationIds == expectedRelations && allowedRelationIds == expectedRelations)
    \"intent must carry every allow relation in relations and allowedRelations\"
  && require (tenantApi.publicIpv4 == \"198.51.100.11/32\")
    \"tenant-api must expose modeled public IPv4\"
  && require (missingOutput.publicIpv4 == \"203.0.113.50/32\")
    \"seeded missing-output tenant service must be modeled\"
  && require (publicWeb.publicIngress.enabled == true && publicWeb.publicIngress.ipv4 == \"198.51.100.14/32\")
    \"public-web must be modeled as public ingress\"
  && require (site.ownership.prefixes == [
    {
      kind = \"tenant\";
      name = \"client\";
      ipv4 = \"10.1.134.0/24\";
      ipv6 = \"fd42:0186:50::/64\";
      publicIpv4 = \"198.51.100.10/32\";
    }
  ])
    \"tenant public IPv4 must be present in ownership.prefixes\"
  && require (endpointNames == [ \"locally-routed-endpoint\" \"provider-owned-endpoint\" ])
    \"local and provider owned endpoints must be modeled\"
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
  .enterprise."mini-smt".site[$trace].publicIpv4DestinationPolicy.destinationClasses as $classes
  | $classes["public-ipv4-destination::198.51.100.10"] as $enterpriseClient
  | $classes["public-ipv4-destination::198.51.100.11"] as $tenantService
  | $classes["public-ipv4-destination::203.0.113.50"] as $seededTenantService
  | $classes["public-ipv4-destination::198.51.100.12"] as $localOwned
  | $classes["public-ipv4-destination::198.51.100.13"] as $providerOwned
  | $classes["public-ipv4-destination::198.51.100.14"] as $publicIngress
  | ($enterpriseClient.destinationClass == "enterprise-client")
    and ($enterpriseClient.ownerKind == "tenant")
    and ($enterpriseClient.ownerName == "client")
    and ($enterpriseClient.source == "ownership.prefixes")
    and ($tenantService.destinationClass == "tenant-service")
    and ($tenantService.ownerName == "tenant-api")
    and ($seededTenantService.destinationClass == "tenant-service")
    and ($seededTenantService.ownerName == "fixture-missing-output")
    and ($localOwned.destinationClass == "locally-owned-routed")
    and ($localOwned.ownerName == "locally-routed-endpoint")
    and ($providerOwned.destinationClass == "provider-owned")
    and ($providerOwned.ownerName == "provider-owned-endpoint")
    and ($publicIngress.destinationClass == "public-ingress")
    and ($publicIngress.ownerName == "public-web")
    and ([
      $enterpriseClient,
      $tenantService,
      $seededTenantService,
      $localOwned,
      $providerOwned,
      $publicIngress
    ] | all(.modelOwned == true and (.ownerName != null) and (.ownerKind != null) and (.source != null)))
' "${tmp_dir}/forwarding.json" >/dev/null || {
  jq '.enterprise."mini-smt".site[$trace].publicIpv4DestinationPolicy' \
    --arg trace "${trace_id}" \
    "${tmp_dir}/forwarding.json" >&2
  fail "forwarding classifier predicates failed"
}

echo "PASS ${trace_id}: source fixture and public IPv4 destination classification"
