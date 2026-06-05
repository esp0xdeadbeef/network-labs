#!/usr/bin/env bash
# GAMP-ID: FS-710-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"

nix eval --impure --expr '
  let
    nameMap = import '"${lab_dir}"'/site-evidence-name-map.nix;
    roleMap = import '"${lab_dir}"'/site-role-map.nix;
    intent = import '"${lab_dir}"'/intent.nix;
    require = cond: msg: if cond then true else throw msg;
    expectedSites = [ "site-clab" "site-hetz" "site-nixos" ];
    expectedProductionNames = {
      site-clab = "esp.clab";
      site-hetz = "esp.hetz";
      site-nixos = "esp.nixos";
    };
    intentHasSite = productionEquivalentName:
      let
        matched = builtins.match "esp\\.(.*)" productionEquivalentName;
      in
        matched != null
        && builtins.hasAttr (builtins.head matched) intent.esp;
    validateNameMapRecord = siteName: record:
      require (builtins.elem siteName expectedSites)
        "site evidence-name mapping must reject unknown site keys"
      && require (record ? controlledEvidenceName)
        "${siteName} must declare controlledEvidenceName explicitly"
      && require (record ? productionEquivalentName)
        "${siteName} must declare productionEquivalentName explicitly"
      && require (record.controlledEvidenceName == siteName)
        "${siteName} controlledEvidenceName must match the controlled SAT evidence key"
      && require (record.productionEquivalentName == builtins.getAttr siteName expectedProductionNames)
        "${siteName} productionEquivalentName must match the modeled SAT source site name"
      && require (intentHasSite record.productionEquivalentName)
        "${siteName} productionEquivalentName must point at a modeled SAT intent site"
      && require (roleMap.${siteName}.sourceSite == record.productionEquivalentName)
        "${siteName} evidence-name mapping must stay separate from but consistent with the site role map"
      && require (record.productionEquivalentName != record.controlledEvidenceName)
        "${siteName} evidence-name mapping must not collapse controlled evidence names into production-equivalent names";
    expectValidationFailure = siteName: record: msg:
      require (!(builtins.tryEval (validateNameMapRecord siteName record)).success) msg;
  in
    require (builtins.attrNames nameMap == expectedSites)
      "site evidence-name mapping must emit exactly site-clab/site-hetz/site-nixos"
    && validateNameMapRecord "site-clab" nameMap.site-clab
    && validateNameMapRecord "site-hetz" nameMap.site-hetz
    && validateNameMapRecord "site-nixos" nameMap.site-nixos
    && expectValidationFailure "site-nixos" (builtins.removeAttrs nameMap.site-nixos [ "productionEquivalentName" ])
      "site evidence-name mapping must fail when productionEquivalentName is missing"
    && expectValidationFailure "site-clab" (nameMap.site-clab // {
      productionEquivalentName = "site-clab";
    })
      "site evidence-name mapping must reject controlled evidence names reused as production-equivalent names"
    && expectValidationFailure "site-prod" nameMap.site-nixos
      "site evidence-name mapping must reject copied fields when the fixture site key is not modeled"
' >/dev/null

echo "PASS s-sigma-site-evidence-name-map"
