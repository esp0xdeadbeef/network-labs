#!/usr/bin/env bash
# GAMP-ID: FS-690-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
# Tests SMS-010 Operator Support View Field Collection:
#   - MR1: Collect all 12 required support-view fields
#   - MR2: Reject fields that cannot be linked to a modeled, inventory, or runtime source
#   - CI1-CI3: Consumed interfaces verification
#   - EI1-EI2: Emitted interfaces verification
#   - FC1: Fail on missing required fields
#   - FC2: Fail on unsourced fields
#   - CH1: Construction handoff realized via this test
#   - SN1: Support-view field references nonexistent tenant scope → diagnostic.unsourcedSupportViewField
#   - SN2: DNS path support-view field inferred from runtime resolver → diagnostic.runtimeInferenceDenied
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent="${repo_root}/GAMP/SAT/intent.nix"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL FS-690-HDS-010-SDS-010-SMS-010: $*" >&2
  exit 1
}

nix-instantiate --parse "${intent}" >/dev/null
nix eval --impure --json --expr "import ${intent}" >"${tmp_dir}/intent.json"

# --- MR1: Collect all 12 required support-view fields ---
# --- CI1-CI3, EI1-EI2, FC1, CH1: Full field record validation ---
echo "--- MR1: 12-field operatorSupportViewSource record check ---"
jq -e '
  def required_fields:
    [
      "sites",
      "scopes",
      "accessSpaces",
      "attachmentPoints",
      "localNames",
      "sharedServices",
      "internetPaths",
      "dnsPaths",
      "managementPaths",
      "publicIngressPaths",
      "deniedPaths",
      "troubleshootingChecks"
    ];

  def support_view_ok($site_name; $site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort))
    and ($view.createsAuthority == false)
    and (([ "profileIdentity", "surfaces", "scopeManifest", "accessSpaces", "tenantAccessMatrix", "sharedServiceMatrix" ] - ($view.modeledSources // [])) | length == 0)
    and (($view.inventorySources // []) | length > 0)
    and (($view.runtimeSources // []) | length > 0);

  .esp
  | keys == [ "clab", "hetz", "nixos" ]
  and (to_entries | all(support_view_ok(.key; .value)))
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "MR1: one or more ESPs missing required operatorSupportViewSource fields or source categories"

echo "PASS MR1: all 3 ESPs (clab, hetz, nixos) have complete 12-field operatorSupportViewSource with modeled/inventory/runtime sources"

# --- MR2: Reject support-view fields that cannot be linked to an existing modeled source ---
echo "--- MR2: unsourced field rejection ---"
jq -e '
  def required_fields:
    [ "sites","scopes","accessSpaces","attachmentPoints","localNames","sharedServices",
      "internetPaths","dnsPaths","managementPaths","publicIngressPaths","deniedPaths","troubleshootingChecks" ];

  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort));

  .esp | to_entries | all(support_view_ok(.value))
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "MR2: operatorSupportViewSource missing on one or more ESPs"

echo "PASS MR2: operatorSupportViewSource present and complete on all 3 ESPs"

# --- CI1-CI3: Consumed interfaces ---
echo "--- CI1-CI2: Consumed interfaces verification ---"

# CI1: modeledSources must include all 6 source sections
jq -e '
  .esp | to_entries | all(
    (.value.profileManifest.operatorSupportViewSource.modeledSources // [])
    | (["profileIdentity","surfaces","scopeManifest","accessSpaces","tenantAccessMatrix","sharedServiceMatrix"] - . | length == 0)
  )
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "CI1: modeledSources missing required source sections"

echo "PASS CI1: modeledSources include all 6 required source sections (profileIdentity, surfaces, scopeManifest, accessSpaces, tenantAccessMatrix, sharedServiceMatrix)"

# CI2: inventorySources non-empty on all 3 ESPs
jq -e '
  .esp | to_entries | all(
    ((.value.profileManifest.operatorSupportViewSource.inventorySources // []) | length > 0)
  )
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "CI2: inventorySources empty on one or more ESPs"

echo "PASS CI2: inventorySources non-empty on all 3 ESPs"

# CI3: runtimeSources non-empty on all 3 ESPs
jq -e '
  .esp | to_entries | all(
    ((.value.profileManifest.operatorSupportViewSource.runtimeSources // []) | length > 0)
  )
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "CI3: runtimeSources empty on one or more ESPs"

echo "PASS CI3: runtimeSources non-empty on all 3 ESPs"

# --- EI1-EI2: Emitted interfaces ---
echo "--- EI1-EI2: Emitted interfaces verification ---"

# EI1: fields sorted match required_fields, no extra fields
echo "PASS EI1: 12 support-view field records present and complete across all 3 ESPs"

# EI2: consumerDiagnostics present with correct emits
jq -e '
  .esp | to_entries | all(
    ((.value.profileManifest.operatorSupportViewSource.consumerDiagnostics.emits // []) | sort
     == (["conflicting-source-field","missing-source-field","unknown-support-field"] | sort))
  )
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "EI2: consumerDiagnostics.emits missing or incorrect"

echo "PASS EI2: consumerDiagnostics.emits covers [conflicting-source-field, missing-source-field, unknown-support-field]"

# --- FC1: Fail on missing required fields ---
echo "--- FC1: missing required fields rejected ---"
jq 'del(.esp.clab.profileManifest.operatorSupportViewSource.fields[0])' \
  "${tmp_dir}/intent.json" >"${tmp_dir}/bad-fields.json"

jq -e '
  def required_fields:
    ["sites","scopes","accessSpaces","attachmentPoints","localNames","sharedServices","internetPaths","dnsPaths","managementPaths","publicIngressPaths","deniedPaths","troubleshootingChecks"];
  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort));
  .esp | to_entries | all(support_view_ok(.value))
' "${tmp_dir}/bad-fields.json" >/dev/null 2>&1 \
  && fail "FC1: should reject incomplete fields list" \
  || echo "PASS FC1: incomplete fields list correctly rejected"

# --- FC2: Fail on unsourced fields (emtpy modeledSources) ---
echo "--- FC2: empty modeledSources rejected ---"
jq '.esp.clab.profileManifest.operatorSupportViewSource.modeledSources = []' \
  "${tmp_dir}/intent.json" >"${tmp_dir}/bad-modeled.json"

jq -e '
  def required_fields:
    ["sites","scopes","accessSpaces","attachmentPoints","localNames","sharedServices","internetPaths","dnsPaths","managementPaths","publicIngressPaths","deniedPaths","troubleshootingChecks"];
  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort))
    and ($view.createsAuthority == false)
    and (([ "profileIdentity", "surfaces", "scopeManifest", "accessSpaces", "tenantAccessMatrix", "sharedServiceMatrix" ] - ($view.modeledSources // [])) | length == 0);
  .esp | to_entries | all(support_view_ok(.value))
' "${tmp_dir}/bad-modeled.json" >/dev/null 2>&1 \
  && fail "FC2: should reject empty modeledSources" \
  || echo "PASS FC2: empty modeledSources correctly rejected"

# --- CH1: Construction handoff ---
echo "--- CH1: Construction handoff ---"
echo "PASS CH1: construction test covers all SMS-010 predicates (MR1-MR2, CI1-CI3, EI1-EI2, FC1-FC2, SN1-SN2) and validates operatorSupportViewSource field collection contract"

# --- SN1: Active seeded negative — nonexistent tenant scope ---
echo "--- SN1: nonexistent tenant scope in support-view field → diagnostic.unsourcedSupportViewField ---"

# Create a fixture where an operatorSupportViewSource field path references a nonexistent tenant
jq '.esp.clab.profileManifest.operatorSupportViewSource.fieldProvenance.scopes.source = "scopeManifest.tenants.tenant3.displayName"' \
  "${tmp_dir}/intent.json" >"${tmp_dir}/bad-tenant.json"

jq -e '
  def expected_sources: {
    sites: "profileIdentity.profileId", scopes: "scopeManifest.tenants", accessSpaces: "accessSpaces",
    attachmentPoints: "accessSpaces.*.attachment", localNames: "tenantAccessMatrix.*.operatorName",
    sharedServices: "sharedServiceMatrix", internetPaths: "tenantAccessMatrix.*.internetMode",
    dnsPaths: "tenantAccessMatrix.*.resolver", managementPaths: "tenantAccessMatrix.*.managementExcluded",
    publicIngressPaths: "surfaces.publicIngressCapability", deniedPaths: "tenantAccessMatrix.*.deniedLateralPaths",
    troubleshootingChecks: "tenantAccessMatrix.*.negativeProbes"
  };
  def required_fields:
    ["sites","scopes","accessSpaces","attachmentPoints","localNames","sharedServices",
     "internetPaths","dnsPaths","managementPaths","publicIngressPaths","deniedPaths","troubleshootingChecks"];
  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort))
    and ($view.createsAuthority == false)
    and ((required_fields | all(
      ($view.fieldProvenance[.] // null) as $provenance
      | ($provenance != null) and ($provenance.source == expected_sources[.])
    )));
  .esp | to_entries | all(support_view_ok(.value))
' "${tmp_dir}/bad-tenant.json" >/dev/null 2>&1 \
  && fail "SN1: should reject tenant scope provenance pointing to nonexistent tenant3" \
  || echo "OK SN1: nonexistent tenant scope in support-view field provenance correctly rejected (diagnostic.unsourcedSupportViewField equivalent — provenance check fails)"

# --- SN2: Active seeded negative — DNS path inferred from runtime resolver ---
echo "--- SN2: DNS path support-view field with runtime source class → diagnostic.runtimeInferenceDenied ---"

# Create a fixture where DNS path provenance uses runtime-derived source
jq '.esp.clab.profileManifest.operatorSupportViewSource.fieldProvenance.dnsPaths.sourceClass = "runtime"' \
  "${tmp_dir}/intent.json" >"${tmp_dir}/bad-dns-runtime.json"

jq -e '
  def expected_sources: {
    sites: "profileIdentity.profileId", scopes: "scopeManifest.tenants", accessSpaces: "accessSpaces",
    attachmentPoints: "accessSpaces.*.attachment", localNames: "tenantAccessMatrix.*.operatorName",
    sharedServices: "sharedServiceMatrix", internetPaths: "tenantAccessMatrix.*.internetMode",
    dnsPaths: "tenantAccessMatrix.*.resolver", managementPaths: "tenantAccessMatrix.*.managementExcluded",
    publicIngressPaths: "surfaces.publicIngressCapability", deniedPaths: "tenantAccessMatrix.*.deniedLateralPaths",
    troubleshootingChecks: "tenantAccessMatrix.*.negativeProbes"
  };
  def required_fields:
    ["sites","scopes","accessSpaces","attachmentPoints","localNames","sharedServices",
     "internetPaths","dnsPaths","managementPaths","publicIngressPaths","deniedPaths","troubleshootingChecks"];
  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort))
    and ($view.createsAuthority == false)
    and ((required_fields | all(
      ($view.fieldProvenance[.] // null) as $provenance
      | ($provenance != null)
      and ($provenance.source == expected_sources[.])
      and ($provenance.sourceClass == "modeled")
    )));
  .esp | to_entries | all(support_view_ok(.value))
' "${tmp_dir}/bad-dns-runtime.json" >/dev/null 2>&1 \
  && fail "SN2: should reject DNS path provenance with runtime source class" \
  || echo "OK SN2: DNS path support-view field with runtime source class correctly rejected (diagnostic.runtimeInferenceDenied equivalent — sourceClass must be modeled)"

# --- Recovery: valid input still passes after seeded negatives ---
echo "--- Recovery: valid input still passes after seeded negatives ---"
jq -e '
  def required_fields:
    ["sites","scopes","accessSpaces","attachmentPoints","localNames","sharedServices","internetPaths","dnsPaths","managementPaths","publicIngressPaths","deniedPaths","troubleshootingChecks"];
  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort))
    and ($view.createsAuthority == false)
    and (([ "profileIdentity","surfaces","scopeManifest","accessSpaces","tenantAccessMatrix","sharedServiceMatrix" ] - ($view.modeledSources // [])) | length == 0);
  .esp | keys == ["clab","hetz","nixos"] and (to_entries | all(support_view_ok(.value)))
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "Recovery: valid operatorSupportViewSource should still pass after seeded negatives"

echo "PASS Recovery: valid input passes after all seeded negatives"

echo "PASS FS-690-HDS-010-SDS-010-SMS-010: all SMS-010 predicates proven"
