#!/usr/bin/env bash
set -euo pipefail

# GAMP-ID: FS-770-HDS-010-SDS-020-SMS-010

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL fs770-hds010-sds020-sms010-realization-fact-binding: $*" >&2
  exit 1
}

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  clab = import (repoRoot + "/GAMP/HAT/emulated-isp-residential-testnet/inventory-clab.nix");
  nixos = import (repoRoot + "/GAMP/HAT/emulated-isp-residential-testnet/inventory-nixos.nix");
  traceId = "FS-770-HDS-010-SDS-020-SMS-010";
  expectedSource = "GAMP/HAT/emulated-isp-residential-testnet/intent.nix";
  expectedProfiles = {
    clab = "GAMP/HAT/emulated-isp-residential-testnet/inventory-clab.nix";
    nixos = "GAMP/HAT/emulated-isp-residential-testnet/inventory-nixos.nix";
  };
  require = cond: msg: if cond then true else throw msg;
  bindingFor = profile: inventory:
    let binding = inventory.commonBehaviorSourceBinding or null;
    in
      if binding == null then {
        profile = profile;
        missing = true;
        sourcePath = null;
        inventoryPath = null;
      } else {
        profile = profile;
        missing = false;
        sourcePath = binding.commonBehaviorSource.path or null;
        inventoryPath = binding.profileBinding.inventoryPath or null;
        traceId = binding.traceId or null;
        bindingKind = binding.profileBinding.bindingKind or null;
        policyAuthority = binding.policyAuthority or { };
      };
  diagnosticsFor = clabInventory: nixosInventory:
    let
      rows = [
        (bindingFor "clab" clabInventory)
        (bindingFor "nixos" nixosInventory)
      ];
      missing = builtins.filter (row: row.missing or false) rows;
      sources = builtins.filter (source: source != null) (map (row: row.sourcePath) rows);
      sourceMismatch =
        sources != [ ]
        && builtins.length (builtins.filter (source: source != builtins.head sources) sources) > 0;
    in
      (map (row: "diagnostic.missingCommonSourceBinding:" + row.profile) missing)
      ++ (if sourceMismatch then [ "diagnostic.splitBehaviorSource" ] else [ ]);
  policyNeutral = policy:
    builtins.all
      (name: (policy.${name} or null) == false)
      [
        "createsRouteAuthority"
        "createsFirewallPolicy"
        "createsDnsPolicy"
        "createsPublicIngress"
        "createsTenantReachability"
        "createsTrustBoundary"
        "createsNetworkBehavior"
      ];
  goodClab = bindingFor "clab" clab;
  goodNixos = bindingFor "nixos" nixos;
  splitNixos = nixos // {
    commonBehaviorSourceBinding = nixos.commonBehaviorSourceBinding // {
      commonBehaviorSource = nixos.commonBehaviorSourceBinding.commonBehaviorSource // {
        path = "GAMP/HAT/emulated-isp-residential-testnet/other-intent.nix";
      };
      profileBinding = nixos.commonBehaviorSourceBinding.profileBinding // {
        behaviorSourcePath = "GAMP/HAT/emulated-isp-residential-testnet/other-intent.nix";
      };
    };
  };
  missingClab = builtins.removeAttrs clab [ "commonBehaviorSourceBinding" ];
in
  require (goodClab.traceId == traceId && goodNixos.traceId == traceId)
    "common source binding trace IDs must match FS-770 SMS"
  && require (goodClab.sourcePath == expectedSource && goodNixos.sourcePath == expectedSource)
    "CLAB and NixOS must bind to the same common behavior source"
  && require (goodClab.inventoryPath == expectedProfiles.clab && goodNixos.inventoryPath == expectedProfiles.nixos)
    "profile bindings must name their owning inventory source"
  && require (goodClab.bindingKind == "profile-inventory-to-common-behavior-source")
    "CLAB binding kind mismatch"
  && require (goodNixos.bindingKind == "profile-inventory-to-common-behavior-source")
    "NixOS binding kind mismatch"
  && require (policyNeutral goodClab.policyAuthority && policyNeutral goodNixos.policyAuthority)
    "common source binding must not create network authority"
  && require (diagnosticsFor clab nixos == [ ])
    "valid CLAB/NixOS binding emitted diagnostics"
  && require (diagnosticsFor clab splitNixos == [ "diagnostic.splitBehaviorSource" ])
    "split behavior source seeded negative did not fail closed"
  && require (diagnosticsFor missingClab nixos == [ "diagnostic.missingCommonSourceBinding:clab" ])
    "missing common source binding seeded negative did not fail closed"
' >/dev/null || fail "Nix evaluation failed"

echo "PASS fs770-hds010-sds020-sms010-realization-fact-binding"
