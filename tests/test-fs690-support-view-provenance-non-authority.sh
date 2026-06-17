#!/usr/bin/env bash
# GAMP-ID: FS-690-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-690-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent="${repo_root}/sat/intent.nix"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs690-support-view-provenance-non-authority: $*" >&2
  exit 1
}

nix-instantiate --parse "${intent}" >/dev/null
nix eval --impure --json --expr "import ${intent}" >"${tmp_dir}/intent.json"

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

  def expected_sources:
    {
      sites: "profileIdentity.profileId",
      scopes: "scopeManifest.tenants",
      accessSpaces: "accessSpaces",
      attachmentPoints: "accessSpaces.*.attachment",
      localNames: "tenantAccessMatrix.*.operatorName",
      sharedServices: "sharedServiceMatrix",
      internetPaths: "tenantAccessMatrix.*.internetMode",
      dnsPaths: "tenantAccessMatrix.*.resolver",
      managementPaths: "tenantAccessMatrix.*.managementExcluded",
      publicIngressPaths: "surfaces.publicIngressCapability",
      deniedPaths: "tenantAccessMatrix.*.deniedLateralPaths",
      troubleshootingChecks: "tenantAccessMatrix.*.negativeProbes"
    };

  def forbidden_authority:
    [ "policy", "route", "dns", "publicIngress", "managementAccess", "addressAssignment", "runtimeBinding" ];

  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort))
    and (($view.fieldProvenance // {}) | keys | sort == (required_fields | sort))
    and ((required_fields | all(
      ($view.fieldProvenance[.] // null) as $provenance
      | ($provenance != null)
      and ($provenance.source == expected_sources[.])
      and ($provenance.sourceClass == "modeled")
    )))
    and ($view.createsAuthority == false)
    and ($view.consumerDiagnostics.mode == "read-only-derived-view")
    and (($view.consumerDiagnostics.emits // []) | sort == ([ "conflicting-source-field", "missing-source-field", "unknown-support-field" ] | sort))
    and (($view.consumerDiagnostics.permittedSideEffects // []) == [ "diagnostic-report" ])
    and ((forbidden_authority - ($view.consumerDiagnostics.prohibitedAuthority // [])) | length == 0);

  .esp
  | keys == [ "clab", "hetz", "nixos" ]
  and (to_entries | all(support_view_ok(.value)))
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "support-view field provenance or non-authority diagnostics are incomplete"

# --- SMS-030 seeded negative: support-view record treated as authority ---

# Seeded negative 1: createsAuthority = true
jq '.esp.clab.profileManifest.operatorSupportViewSource.createsAuthority = true' \
  "${tmp_dir}/intent.json" >"${tmp_dir}/bad-authority.json"

jq -e '
  def required_fields:
    ["sites","scopes","accessSpaces","attachmentPoints","localNames","sharedServices","internetPaths","dnsPaths","managementPaths","publicIngressPaths","deniedPaths","troubleshootingChecks"];
  def expected_sources: {
    sites: "profileIdentity.profileId", scopes: "scopeManifest.tenants", accessSpaces: "accessSpaces",
    attachmentPoints: "accessSpaces.*.attachment", localNames: "tenantAccessMatrix.*.operatorName",
    sharedServices: "sharedServiceMatrix", internetPaths: "tenantAccessMatrix.*.internetMode",
    dnsPaths: "tenantAccessMatrix.*.resolver", managementPaths: "tenantAccessMatrix.*.managementExcluded",
    publicIngressPaths: "surfaces.publicIngressCapability", deniedPaths: "tenantAccessMatrix.*.deniedLateralPaths",
    troubleshootingChecks: "tenantAccessMatrix.*.negativeProbes"
  };
  def forbidden_authority: ["policy","route","dns","publicIngress","managementAccess","addressAssignment","runtimeBinding"];
  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort))
    and (($view.fieldProvenance // {}) | keys | sort == (required_fields | sort))
    and ((required_fields | all(
      ($view.fieldProvenance[.] // null) as $provenance
      | ($provenance != null) and ($provenance.source == expected_sources[.]) and ($provenance.sourceClass == "modeled")
    )))
    and ($view.createsAuthority == false)
    and ($view.consumerDiagnostics.mode == "read-only-derived-view")
    and (($view.consumerDiagnostics.emits // []) | sort == (["conflicting-source-field","missing-source-field","unknown-support-field"] | sort))
    and (($view.consumerDiagnostics.permittedSideEffects // []) == ["diagnostic-report"])
    and ((forbidden_authority - ($view.consumerDiagnostics.prohibitedAuthority // [])) | length == 0);
  .esp | keys == ["clab","hetz","nixos"] and (to_entries | all(support_view_ok(.value)))
' "${tmp_dir}/bad-authority.json" >/dev/null 2>&1 \
  && fail "seeded-negative-1: should reject createsAuthority=true" \
  || echo "OK: seeded-negative-1 — createsAuthority=true correctly rejected"

# Seeded negative 2: prohibitedAuthority missing 'dns'
jq '.esp.clab.profileManifest.operatorSupportViewSource.consumerDiagnostics.prohibitedAuthority = ["policy","route","publicIngress","managementAccess","addressAssignment","runtimeBinding"]' \
  "${tmp_dir}/intent.json" >"${tmp_dir}/bad-prohibited.json"

jq -e '
  def required_fields:
    ["sites","scopes","accessSpaces","attachmentPoints","localNames","sharedServices","internetPaths","dnsPaths","managementPaths","publicIngressPaths","deniedPaths","troubleshootingChecks"];
  def expected_sources: {
    sites: "profileIdentity.profileId", scopes: "scopeManifest.tenants", accessSpaces: "accessSpaces",
    attachmentPoints: "accessSpaces.*.attachment", localNames: "tenantAccessMatrix.*.operatorName",
    sharedServices: "sharedServiceMatrix", internetPaths: "tenantAccessMatrix.*.internetMode",
    dnsPaths: "tenantAccessMatrix.*.resolver", managementPaths: "tenantAccessMatrix.*.managementExcluded",
    publicIngressPaths: "surfaces.publicIngressCapability", deniedPaths: "tenantAccessMatrix.*.deniedLateralPaths",
    troubleshootingChecks: "tenantAccessMatrix.*.negativeProbes"
  };
  def forbidden_authority: ["policy","route","dns","publicIngress","managementAccess","addressAssignment","runtimeBinding"];
  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort))
    and (($view.fieldProvenance // {}) | keys | sort == (required_fields | sort))
    and ((required_fields | all(
      ($view.fieldProvenance[.] // null) as $provenance
      | ($provenance != null) and ($provenance.source == expected_sources[.]) and ($provenance.sourceClass == "modeled")
    )))
    and ($view.createsAuthority == false)
    and ($view.consumerDiagnostics.mode == "read-only-derived-view")
    and (($view.consumerDiagnostics.emits // []) | sort == (["conflicting-source-field","missing-source-field","unknown-support-field"] | sort))
    and (($view.consumerDiagnostics.permittedSideEffects // []) == ["diagnostic-report"])
    and ((forbidden_authority - ($view.consumerDiagnostics.prohibitedAuthority // [])) | length == 0);
  .esp | keys == ["clab","hetz","nixos"] and (to_entries | all(support_view_ok(.value)))
' "${tmp_dir}/bad-prohibited.json" >/dev/null 2>&1 \
  && fail "seeded-negative-2: should reject prohibitedAuthority missing dns" \
  || echo "OK: seeded-negative-2 — prohibitedAuthority missing dns correctly rejected"

# Verify valid input still passes after seeded negatives
jq -e '
  def required_fields:
    ["sites","scopes","accessSpaces","attachmentPoints","localNames","sharedServices","internetPaths","dnsPaths","managementPaths","publicIngressPaths","deniedPaths","troubleshootingChecks"];
  def expected_sources: {
    sites: "profileIdentity.profileId", scopes: "scopeManifest.tenants", accessSpaces: "accessSpaces",
    attachmentPoints: "accessSpaces.*.attachment", localNames: "tenantAccessMatrix.*.operatorName",
    sharedServices: "sharedServiceMatrix", internetPaths: "tenantAccessMatrix.*.internetMode",
    dnsPaths: "tenantAccessMatrix.*.resolver", managementPaths: "tenantAccessMatrix.*.managementExcluded",
    publicIngressPaths: "surfaces.publicIngressCapability", deniedPaths: "tenantAccessMatrix.*.deniedLateralPaths",
    troubleshootingChecks: "tenantAccessMatrix.*.negativeProbes"
  };
  def forbidden_authority: ["policy","route","dns","publicIngress","managementAccess","addressAssignment","runtimeBinding"];
  def support_view_ok($site):
    ($site.profileManifest.operatorSupportViewSource // null) as $view
    | ($view != null)
    and (($view.fields // []) | sort == (required_fields | sort))
    and (($view.fieldProvenance // {}) | keys | sort == (required_fields | sort))
    and ((required_fields | all(
      ($view.fieldProvenance[.] // null) as $provenance
      | ($provenance != null) and ($provenance.source == expected_sources[.]) and ($provenance.sourceClass == "modeled")
    )))
    and ($view.createsAuthority == false)
    and ($view.consumerDiagnostics.mode == "read-only-derived-view")
    and (($view.consumerDiagnostics.emits // []) | sort == (["conflicting-source-field","missing-source-field","unknown-support-field"] | sort))
    and (($view.consumerDiagnostics.permittedSideEffects // []) == ["diagnostic-report"])
    and ((forbidden_authority - ($view.consumerDiagnostics.prohibitedAuthority // [])) | length == 0);
  .esp | keys == ["clab","hetz","nixos"] and (to_entries | all(support_view_ok(.value)))
' "${tmp_dir}/intent.json" >/dev/null \
  || fail "valid-input-after-seeded-negatives: valid support view should still pass"

echo "PASS fs690-support-view-provenance-non-authority"
