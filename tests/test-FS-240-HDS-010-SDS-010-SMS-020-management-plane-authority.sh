#!/usr/bin/env bash
# GAMP-ID: FS-240-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test — row-local focused test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    authority = import '"${lab_dir}"'/management-core-host-authority.nix;
    roleMap = import '"${lab_dir}"'/site-role-map.nix;
    require = cond: msg: if cond then true else throw msg;
    expectedSites = [ "site-clab" "site-hetz" "site-nixos" ];
    allowedManagementClasses = [ "management" ];
    allowedCoreTrafficClasses = [ "host-management" "control-plane" ];
    hasNonEmpty = record: name: record ? ${name} && builtins.isString record.${name} && record.${name} != "";
    hasPorts = record: record ? ports && record.ports != [ ] && builtins.all builtins.isInt record.ports;
    uniqueIds = records:
      builtins.length (builtins.attrNames (builtins.listToAttrs (map (record: { name = record.id; value = true; }) records)))
        == builtins.length records;
    validateManagementAccess = siteName: access:
      require (hasNonEmpty access "id")
        "${siteName} management access must declare id"
      && require (hasNonEmpty access "policyClass" && builtins.elem access.policyClass allowedManagementClasses)
        "${siteName} management access must declare management policy class"
      && require (hasNonEmpty access "sourceScope")
        "${siteName} management access must declare source scope"
      && require (hasNonEmpty access "targetRole")
        "${siteName} management access must declare target role"
      && require (hasNonEmpty access "targetHost")
        "${siteName} management access must declare target host"
      && require (hasNonEmpty access "protocol")
        "${siteName} management access must declare protocol"
      && require (hasPorts access)
        "${siteName} management access must declare one or more ports"
      && require (hasNonEmpty access "authenticationBoundary")
        "${siteName} management access must declare authentication boundary"
      && require (hasNonEmpty access "recoveryMode")
        "${siteName} management access must declare recovery mode"
      && require (access ? nonManagementAuthority && access.nonManagementAuthority == false)
        "${siteName} management access must not grant non-management authority";
    validateCoreException = siteName: exception:
      require (hasNonEmpty exception "id")
        "${siteName} core-host exception must declare id"
      && require (hasNonEmpty exception "sourceScope")
        "${siteName} core-host exception must declare source scope"
      && require (hasNonEmpty exception "targetRole" && exception.targetRole == "core-boundary")
        "${siteName} core-host exception must target the core boundary"
      && require (hasNonEmpty exception "targetAddress")
        "${siteName} core-host exception must declare target address"
      && require (hasNonEmpty exception "protocol")
        "${siteName} core-host exception must declare protocol"
      && require (hasPorts exception)
        "${siteName} core-host exception must declare one or more ports"
      && require (hasNonEmpty exception "attachmentSurface")
        "${siteName} core-host exception must declare attachment surface"
      && require (hasNonEmpty exception "trafficClass" && builtins.elem exception.trafficClass allowedCoreTrafficClasses)
        "${siteName} core-host exception must declare host-management or control-plane traffic class"
      && require (exception ? forwardingSideEffects && exception.forwardingSideEffects == false)
        "${siteName} core-host exception must not create forwarding side effects"
      && require (exception ? serviceExposure && exception.serviceExposure == false)
        "${siteName} core-host exception must not create service exposure";
    validateSite = siteName: record:
      require (builtins.elem siteName expectedSites)
        "authority validation must reject unknown site keys"
      && require (record ? sourceSite && record.sourceSite == roleMap.${siteName}.sourceSite)
        "${siteName} authority sourceSite must match site-role source"
      && require (record ? managementAccess && record.managementAccess != [ ])
        "${siteName} must declare management access tuples"
      && require (record ? coreHostExceptions && record.coreHostExceptions != [ ])
        "${siteName} must declare core-host exception tuples"
      && require (uniqueIds record.managementAccess)
        "${siteName} management access ids must be unique"
      && require (uniqueIds record.coreHostExceptions)
        "${siteName} core-host exception ids must be unique"
      && builtins.all (validateManagementAccess siteName) record.managementAccess
      && builtins.all (validateCoreException siteName) record.coreHostExceptions;
    expectFailure = value: msg:
      require (!(builtins.tryEval value).success) msg;
    firstMgmt = builtins.head authority.site-nixos.managementAccess;
    firstException = builtins.head authority.site-nixos.coreHostExceptions;
  in
    require (builtins.attrNames authority == expectedSites)
      "authority source must emit exactly site-clab/site-hetz/site-nixos"
    && builtins.all (siteName: validateSite siteName authority.${siteName}) expectedSites
    && expectFailure (validateManagementAccess "site-nixos" (builtins.removeAttrs firstMgmt [ "sourceScope" ]))
      "management authority validation must reject missing source scope"
    && expectFailure (validateManagementAccess "site-nixos" (builtins.removeAttrs firstMgmt [ "targetHost" ]))
      "management authority validation must reject missing target host"
    && expectFailure (validateManagementAccess "site-nixos" (builtins.removeAttrs firstMgmt [ "authenticationBoundary" ]))
      "management authority validation must reject missing authentication boundary"
    && expectFailure (validateManagementAccess "site-nixos" (builtins.removeAttrs firstMgmt [ "recoveryMode" ]))
      "management authority validation must reject missing recovery mode"
    && expectFailure (validateManagementAccess "site-nixos" (firstMgmt // { nonManagementAuthority = true; }))
      "management authority validation must reject non-management authority reuse"
    && expectFailure (validateCoreException "site-nixos" (builtins.removeAttrs firstException [ "targetAddress" ]))
      "core-host exception validation must reject missing target address"
    && expectFailure (validateCoreException "site-nixos" (firstException // { targetRole = "tenant-access"; }))
      "core-host exception validation must reject non-core targets"
    && expectFailure (validateCoreException "site-nixos" (firstException // { trafficClass = "payload"; }))
      "core-host exception validation must reject payload traffic as exempt"
    && expectFailure (validateCoreException "site-nixos" (firstException // { forwardingSideEffects = true; }))
      "core-host exception validation must reject forwarding side effects"
' >/dev/null

echo "PASS FS-240-HDS-010-SDS-010-SMS-020 management-plane-authority-exclusion"
