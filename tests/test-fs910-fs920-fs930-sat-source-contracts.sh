#!/usr/bin/env bash
# GAMP-ID: FS-910-HDS-010-SDS-010
# GAMP-ID: FS-920-HDS-010-SDS-011
# GAMP-ID: FS-920-HDS-010-SDS-012
# GAMP-ID: FS-920-HDS-010-SDS-013
# GAMP-ID: FS-930-HDS-010-SDS-011
# GAMP-ID: FS-930-HDS-010-SDS-012
# GAMP-ID: FS-930-HDS-010-SDS-013
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"
# SMS-020 CMC: cpm_flake removed — downstream entrypoint reference.
# CPM compile-and-build invocation and jq validation of CPM output
# are downstream-dependent and must live in network-control-plane-model/tests/.

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

source_json="${tmp_dir}/source.json"
inventory_nix="${tmp_dir}/inventory-nixos.nix"
cpm_json="${tmp_dir}/cpm.json"

fail() {
  echo "FAIL fs910-fs920-fs930-sat-source-contracts: $*" >&2
  exit 1
}

nix eval --impure --json --expr "{
  raw = import ${lab_dir}/inventory.nix;
  resolved = import ${lab_dir}/getResolvedInventory.nix { renderer = \"nixos\"; };
}" >"${source_json}"

jq -e '
  def expected_privacy_classes:
    [
      "dns-query",
      "client-identity",
      "service-discovery",
      "flow-summary",
      "lease-state",
      "provider-state",
      "validation-failure-detail"
    ];
  def expected_failures:
    [
      "provider-loss",
      "overlay-loss",
      "dns-failure",
      "route-withdrawal",
      "route-leak",
      "address-conflict",
      "state-loss",
      "ingress-conflict",
      "nat-exhaustion",
      "nat66-exhaustion",
      "secret-expiry"
    ];
  def expected_responses:
    [
      "fail-closed",
      "failover",
      "retry",
      "degraded-service"
    ];
  def expected_diag_fields:
    [
      "owningLayer",
      "affectedScope",
      "input",
      "reason",
      "sourceLocation"
    ];
  def expected_value_classes:
    [
      "behavior",
      "public-inventory",
      "protected-inventory",
      "runtime-fact",
      "target-limitation",
      "validation-context-data"
    ];
  def expected_input_states:
    [
      "missing",
      "stale",
      "mismatched",
      "conflicting",
      "ambiguous"
    ];
  def has_all($expected; $actual):
    $actual as $actual_values
    | all($expected[]; . as $expected_value | $actual_values | index($expected_value) != null);
  def authority_closed($authority):
    $authority.defaultBehavior == "deny-by-default"
    and $authority.unmodeledFallbackAuthority == false
    and $authority.createsDnsFallback == false
    and $authority.createsRouteFallback == false
    and $authority.createsPublicIngress == false
    and $authority.createsTenantReachability == false
    and $authority.createsManagementReachability == false
    and $authority.createsEgressAuthority == false;
  def valid_privacy($privacy):
    $privacy.marker == "SAT-SRC-INVENTORY-OPERATIONAL-PRIVACY"
    and $privacy.defaultHigherDetailEnabled == false
    and $privacy.explicitScopedDetailModeRequired == true
    and has_all(["modeled-context", "validation-context"]; $privacy.allowedDetailSelectionContexts)
    and has_all(expected_privacy_classes; [$privacy.metadataSurfaces[].metadataClass])
    and all($privacy.metadataSurfaces[];
      (.classification | type == "string" and length > 0)
      and (.retention | type == "string" and length > 0)
      and (.access | type == "string" and length > 0)
      and (.redaction | type == "string" and length > 0)
      and (.detailScope | type == "array" and length > 0)
      and (.sourceLocation | type == "string" and length > 0)
    )
    and has_all([
      "FS-910-HDS-010-SDS-010",
      "FS-910-HDS-010-SDS-010-SMS-010",
      "FS-910-HDS-010-SDS-010-SMS-020",
      "FS-910-HDS-010-SDS-010-SMS-030"
    ]; $privacy.gampIds);
  def valid_failure_handling($failure):
    $failure.marker == "SAT-SRC-INVENTORY-FAILURE-HANDLING"
    and authority_closed($failure.responseAuthority)
    and has_all(expected_failures; [$failure.modeledFailureClasses[].failureClass])
    and all($failure.modeledFailureClasses[];
      (.response as $response | expected_responses | index($response) != null)
      and (.affectedSurface | type == "string" and length > 0)
      and (.sourceLocation | type == "string" and length > 0)
    )
    and ([$failure.modeledFailureClasses[].failureClass] | length == (unique | length))
    and has_all([
      "FS-920-HDS-010-SDS-011",
      "FS-920-HDS-010-SDS-012",
      "FS-920-HDS-010-SDS-013",
      "FS-920-HDS-010-SDS-010-SMS-010",
      "FS-920-HDS-010-SDS-010-SMS-020",
      "FS-920-HDS-010-SDS-010-SMS-030"
    ]; $failure.gampIds);
  def valid_diagnostics($diag):
    $diag.marker == "SAT-SRC-INVENTORY-FAILURE-DIAGNOSTICS"
    and has_all(expected_diag_fields; $diag.requiredDiagnosticFields)
    and has_all(expected_input_states; $diag.inputStates)
    and has_all(expected_value_classes; $diag.valueClasses)
    and $diag.redaction.preserveCorrelation == true
    and $diag.redaction.exposePlaintextSecrets == false
    and $diag.redaction.exposeFullPayloads == false
    and $diag.redaction.exposeUnboundedDebug == false
    and $diag.repairRouting.routeMalformedInputToOwningSourceLayer == true
    and $diag.repairRouting.lowerLayerHeuristicRepairAllowed == false
    and $diag.repairRouting.rendererLocalRepairAllowed == false
    and $diag.repairRouting.scriptLocalRepairAllowed == false
    and all($diag.diagnosticTaxonomy[];
      (.code | type == "string" and length > 0)
      and (.owningLayer | type == "string" and length > 0)
      and (.valueClass as $value_class | expected_value_classes | index($value_class) != null)
      and (.reason | type == "string" and length > 0)
    )
    and has_all([
      "FS-930-HDS-010-SDS-011",
      "FS-930-HDS-010-SDS-012",
      "FS-930-HDS-010-SDS-013",
      "FS-930-HDS-010-SDS-010-SMS-010",
      "FS-930-HDS-010-SDS-010-SMS-020",
      "FS-930-HDS-010-SDS-010-SMS-030"
    ]; $diag.gampIds);
  def valid_source:
    valid_privacy(.operationalPrivacyContracts)
    and valid_failure_handling(.failureHandlingContracts)
    and valid_diagnostics(.failureDiagnosticContracts);
  .raw as $raw
  | .resolved as $resolved
  | ($raw | valid_source)
  and ($resolved | valid_source)
  and (($raw | .operationalPrivacyContracts.metadataSurfaces |= map(select(.metadataClass != "dns-query")) | valid_source) | not)
  and (($raw | .operationalPrivacyContracts.defaultHigherDetailEnabled = true | valid_source) | not)
  and (($raw | .failureHandlingContracts.modeledFailureClasses |= map(select(.failureClass != "provider-loss")) | valid_source) | not)
  and (($raw | .failureHandlingContracts.responseAuthority.createsDnsFallback = true | valid_source) | not)
  and (($raw | .failureDiagnosticContracts.requiredDiagnosticFields |= map(select(. != "sourceLocation")) | valid_source) | not)
  and (($raw | .failureDiagnosticContracts.repairRouting.lowerLayerHeuristicRepairAllowed = true | valid_source) | not)
' "${source_json}" >/dev/null || fail "controlled SAT source atoms are missing or malformed"

echo "PASS fs910-fs920-fs930-sat-source-contracts"
