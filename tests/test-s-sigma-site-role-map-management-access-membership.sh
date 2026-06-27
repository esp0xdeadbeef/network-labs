#!/usr/bin/env bash
# GAMP-ID: FS-710-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    roleMap = import '"${lab_dir}"'/site-role-map.nix;
    intent = import '"${lab_dir}"'/intent.nix;
    require = cond: msg: if cond then true else throw msg;
    expectedSites = [ "site-clab" "site-hetz" "site-nixos" ];
    tenantSpacesFor = site:
      builtins.map
        (name: builtins.substring 7 ((builtins.stringLength name) - 7) name)
        (builtins.filter
          (name: builtins.match "tenant-.*" name != null)
          (builtins.attrNames site.communicationContract.interfaceTags));
    expectedManagementBoundary = {
      site-clab = {
        kind = "tenant";
        tenant = "mgmt";
        adminAllowRelation = "allow-admin-to-mgmt";
        deniedRelations = [ "deny-production-to-mgmt" ];
      };
      site-hetz = {
        kind = "external-harness";
        note = "No local mgmt tenant is modeled in esp.hetz; management remains outside the hosted edge tenant set.";
      };
      site-nixos = {
        kind = "tenant";
        tenant = "mgmt";
        adminAllowRelation = "allow-admin-to-mgmt";
        deniedRelations = [ "deny-production-to-mgmt" ];
      };
    };
    expectedTenantSpaces = {
      site-clab = tenantSpacesFor intent.esp.clab;
      site-hetz = tenantSpacesFor intent.esp.hetz;
      site-nixos = tenantSpacesFor intent.esp.nixos;
    };
    validateMembershipRecord = siteName: record:
      require (builtins.elem siteName expectedSites)
        "management/access validation must reject unknown site keys"
      && (let
        expectedBoundary = builtins.getAttr siteName expectedManagementBoundary;
        expectedSpaces = builtins.getAttr siteName expectedTenantSpaces;
      in
        require (record ? managementBoundary)
          "${siteName} must declare a managementBoundary explicitly"
        && require (record ? tenantOrAccessSpaces)
          "${siteName} must declare tenantOrAccessSpaces explicitly"
        && require (record.managementBoundary == expectedBoundary)
          "${siteName} managementBoundary must match the controlled SAT boundary"
        && require (record.tenantOrAccessSpaces == expectedSpaces)
          "${siteName} tenantOrAccessSpaces must match explicit intent tenant tags");
    expectValidationFailure = siteName: record: msg:
      require (!(builtins.tryEval (validateMembershipRecord siteName record)).success) msg;
  in
    validateMembershipRecord "site-clab" roleMap.site-clab
    && validateMembershipRecord "site-hetz" roleMap.site-hetz
    && validateMembershipRecord "site-nixos" roleMap.site-nixos
    && expectValidationFailure "site-hetz" (roleMap.site-hetz // {
      managementBoundary = {
        kind = "tenant";
        tenant = "mgmt";
        adminAllowRelation = "allow-admin-to-mgmt";
        deniedRelations = [ "deny-production-to-mgmt" ];
      };
    })
      "management/access validation must reject management authority invented from generic fixture naming or host placement"
    && expectValidationFailure "site-nixos" (roleMap.site-nixos // {
      tenantOrAccessSpaces = roleMap.site-nixos.tenantOrAccessSpaces ++ [ "site-nixos" ];
    })
      "management/access validation must reject tenant/access membership invented from fixture site names"
    && expectValidationFailure "site-clab" (builtins.removeAttrs roleMap.site-clab [ "managementBoundary" ])
      "management/access validation must fail when managementBoundary is missing"
' >/dev/null

echo "PASS s-sigma-site-role-map-management-access-membership"
