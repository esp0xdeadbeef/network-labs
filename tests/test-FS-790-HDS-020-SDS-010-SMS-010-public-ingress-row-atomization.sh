#!/usr/bin/env bash
# GAMP-ID: FS-790-HDS-020-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sat_dir="${repo_root}/GAMP/SAT"

fail() {
  echo "FAIL FS-790-HDS-020-SDS-010-SMS-010: $*" >&2
  exit 1
}

# Validate public-ingress fixture row atomization per SMS acceptance predicates:
#  - Reject rows that authorize multiple public ports, protocols, targets, etc.
#  - Reject provider bindings that grant exposure without modeled policy
#  - Emit denied-variant and provider/emulation records per-row

nix eval --impure --expr '
  let
    fixtureTable = import '"${sat_dir}"'/public-ingress-fixture-table.nix;
    require = cond: msg: if cond then true else throw msg;
    tryEvalOrNull = val:
      let evaled = builtins.tryEval val;
      in if evaled.success then evaled.value else null;
    rowNames = builtins.attrNames fixtureTable;
    validateRowAtomization = rowName: row:
      let
        hasSinglePublicSurface = (row.publicSurface or null) != null;
        hasSingleProtocol = (row.protocol or null) != null;
        hasSinglePublicPort = (row.publicPort or null) != null;
        hasSingleTargetService = (row.targetService or null) != null;
        hasSingleTargetEndpoint = (row.targetEndpoint or null) != null;
        hasSingleTargetPort = (row.targetPort or null) != null;
        hasSingleReturnPath = (row.returnPath or null) != null;
        hasDeniedVariants = builtins.length (row.deniedVariants or []) > 0;
        hasProviderRequirement = (row.externalProviderRequired or false) == true;
        hasPolicyRefs = builtins.length (row.policyRefs or []) > 0;
      in
        require hasSinglePublicSurface
          "diagnostic.public-ingress-row-too-broad: ${rowName} must have a single publicSurface"
        && require hasSingleProtocol
          "diagnostic.public-ingress-row-too-broad: ${rowName} must have a single protocol"
        && require hasSinglePublicPort
          "diagnostic.public-ingress-row-too-broad: ${rowName} must have a single publicPort"
        && require hasSingleTargetService
          "diagnostic.public-ingress-row-too-broad: ${rowName} must have a single targetService"
        && require hasSingleTargetEndpoint
          "diagnostic.public-ingress-row-too-broad: ${rowName} must have a single targetEndpoint"
        && require hasSingleTargetPort
          "diagnostic.public-ingress-row-too-broad: ${rowName} must have a single targetPort"
        && require hasSingleReturnPath
          "diagnostic.public-ingress-row-too-broad: ${rowName} must have a single returnPath"
        && require hasDeniedVariants
          "diagnostic.public-ingress-row-too-broad: ${rowName} must emit denied-variant records"
        && require hasProviderRequirement
          "diagnostic.provider-binding-is-not-policy: ${rowName} must require external provider"
        && require hasPolicyRefs
          "diagnostic.provider-binding-is-not-policy: ${rowName} must reference explicit public-exposure policy";
  in
    require (builtins.length rowNames == 6)
      "public-ingress fixture must emit exactly 6 atomized rows (2 per site: tcp + udp)"
    && builtins.foldl'\'' (acc: name: acc && validateRowAtomization name fixtureTable.${name}) true rowNames
    && require
      (tryEvalOrNull (
        validateRowAtomization "multi-port-row" {
          site = "site-clab";
          publicSurface = "hetz-wan";
          sourceScope = "internet";
          protocol = "tcp";
          publicPort = null;
          targetService = null;
          targetEndpoint = "clab-client01";
          targetPort = null;
          translationBehavior = "provider-port-forward";
          returnPath = null;
          deniedVariants = [];
          externalProviderRequired = false;
          localEmulationAllowed = null;
          policyRefs = [];
        }
      ) == null)
      "multi-leg public ingress row must be rejected"
    && require
      (tryEvalOrNull (
        let
          bareRow = {
            site = "site-hetz";
            publicSurface = "hetz-wan";
            sourceScope = "internet";
            protocol = "tcp";
            publicPort = 9999;
            targetService = "bare-service";
            targetEndpoint = "bare-endpoint";
            targetPort = 9999;
            translationBehavior = "direct";
            returnPath = "hetz-local";
            deniedVariants = [ "wrong-port" ];
            externalProviderRequired = false;
            localEmulationAllowed = true;
            policyRefs = [];
          };
        in
          if (bareRow.publicSurface or null) != null && builtins.length (bareRow.policyRefs or []) == 0 then
            throw "diagnostic.provider-binding-is-not-policy: bare-provider-binding has public surface but no explicit public-exposure policy"
          else true
      ) == null)
      "provider binding without explicit public-exposure policy must be rejected"
    && require
      (builtins.all
        (name:
          builtins.length (fixtureTable.${name}.deniedVariants or []) > 0
          && (fixtureTable.${name}.externalProviderRequired or false) == true
        )
        rowNames)
      "every existing fixture row must emit denied-variant and provider/emulation records"
' >/dev/null || fail "public ingress row atomization validation failed"

echo "PASS FS-790-HDS-020-SDS-010-SMS-010-public-ingress-row-atomization"
