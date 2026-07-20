#!/usr/bin/env bash
# GAMP-ID: FS-710-HDS-010-SDS-010-SMS-005
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    roleMap = import '"${lab_dir}"'/site-role-map.nix;
    inventory = import '"${lab_dir}"'/inventory.nix;
    require = cond: msg: if cond then true else throw msg;
    expectedSites = [ "site-clab" "site-hetz" "site-nixos" ];
    expected = {
      site-clab = {
        sourceSite = "esp.clab";
        acceptanceRole = "containerlab-mirror";
        supportedLabProfile = "containerlab";
      };
      site-hetz = {
        sourceSite = "esp.hetz";
        acceptanceRole = "hosted-edge-public-entry";
        supportedLabProfile = "hetzner";
      };
      site-nixos = {
        sourceSite = "esp.nixos";
        acceptanceRole = "home-server-network";
        supportedLabProfile = "nixos";
      };
    };
    validateIdentityRecord = siteName: record:
      require (builtins.elem siteName expectedSites)
        "site-role identity must reject unknown site keys"
      && (let
        expectedRecord = builtins.getAttr siteName expected;
      in
        require (record ? sourceSite)
          "${siteName} must declare sourceSite explicitly"
        && require (record ? acceptanceRole)
          "${siteName} must declare acceptanceRole explicitly"
        && require (record ? supportedLabProfile)
          "${siteName} must declare supportedLabProfile explicitly"
        && require (record.sourceSite == expectedRecord.sourceSite)
          "${siteName} sourceSite must match the controlled SAT source site"
        && require (record.acceptanceRole == expectedRecord.acceptanceRole)
          "${siteName} acceptanceRole must match the controlled acceptance role"
        && require (record.supportedLabProfile == expectedRecord.supportedLabProfile)
          "${siteName} supportedLabProfile must match the controlled lab profile");
    expectValidationFailure = siteName: record: msg:
      require (!(builtins.tryEval (validateIdentityRecord siteName record)).success) msg;
  in
    require (builtins.attrNames roleMap == expectedSites)
      "site-role identity map must emit exactly site-clab/site-hetz/site-nixos"
    && validateIdentityRecord "site-clab" roleMap.site-clab
    && validateIdentityRecord "site-hetz" roleMap.site-hetz
    && validateIdentityRecord "site-nixos" roleMap.site-nixos
    && require (inventory.controlPlane.sites.esp ? clab && inventory.controlPlane.sites.esp ? hetz && inventory.controlPlane.sites.esp ? nixos)
      "site-role identity map must consume the current SAT inventory site surface"
    && expectValidationFailure "site-prod" roleMap.site-nixos
      "site-role identity validation must reject copied fields when the fixture site key is not modeled"
    && expectValidationFailure "site-nixos" (builtins.removeAttrs roleMap.site-nixos [ "sourceSite" ])
      "site-role identity validation must fail when sourceSite is missing"
    && expectValidationFailure "site-clab" (roleMap.site-clab // { acceptanceRole = "site-clab"; })
      "site-role identity validation must reject acceptance roles invented from fixture site names"
' >/dev/null

echo "PASS s-sigma-site-role-map-identity"
