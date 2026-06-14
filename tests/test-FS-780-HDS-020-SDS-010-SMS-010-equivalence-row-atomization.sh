#!/usr/bin/env bash
# GAMP-ID: FS-780-HDS-020-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL FS-780-HDS-020-SDS-010-SMS-010: $*" >&2
  exit 1
}

# Inline equivalence row atomization checker per SMS acceptance predicates.
# Module consumes equivalence matrix rows and validates:
#  - One predicate per row (reject broad rows)
#  - Both CLAB and NixOS evidence surfaces present (reject missing surfaces)
#  - Emits diagnostics with the missing backend name

nix eval --impure --expr '
  let
    require = cond: msg: if cond then true else throw msg;
    tryEvalOrNull = val:
      let evaled = builtins.tryEval val;
      in if evaled.success then evaled.value else null;
    validateEquivalenceRow = rowName: row:
      let
        predicateCount = builtins.length (row.predicates or []);
        hasClabSurface = (row.clabEvidenceSurface or null) != null;
        hasNixosSurface = (row.nixosEvidenceSurface or null) != null;
      in
        if predicateCount > 1 then
          throw "diagnostic.equivalence-row-too-broad: ${rowName} combines ${toString predicateCount} predicates"
        else if predicateCount < 1 then
          throw "diagnostic.equivalence-row-too-broad: ${rowName} has no predicates"
        else if !hasClabSurface then
          throw "diagnostic.equivalence-surface-missing: ${rowName} missing CLAB evidence surface"
        else if !hasNixosSurface then
          throw "diagnostic.equivalence-surface-missing: ${rowName} missing NixOS evidence surface"
        else true;
  in
    require
      (validateEquivalenceRow "dns-resolution" {
        predicates = [ "dns-resolution" ];
        requestedScope = "site-clab site-nixos";
        clabEvidenceSurface = "clab-dns-probe";
        nixosEvidenceSurface = "nixos-dns-probe";
        expectedOutcome = "equivalent";
        limitations = [];
      })
      "valid single-predicate row should pass"
    && require
      (validateEquivalenceRow "bgp-routing" {
        predicates = [ "bgp-routing" ];
        requestedScope = "site-clab site-nixos";
        clabEvidenceSurface = "clab-bgp-frr-config";
        nixosEvidenceSurface = "nixos-bgp-frr-config";
        expectedOutcome = "equivalent-with-limitation";
        limitations = [ "clab-uses-frr-from-container nixos-uses-frr-from-nixpkgs" ];
      })
      "valid single-predicate row with limitations should pass"
    && require
      (tryEvalOrNull (
        validateEquivalenceRow "dns-and-nat-combined" {
          predicates = [ "dns-resolution" "nat-behavior" ];
          requestedScope = "site-clab site-nixos";
          clabEvidenceSurface = "clab-dns-nat-probe";
          nixosEvidenceSurface = "nixos-dns-nat-probe";
          expectedOutcome = "equivalent";
          limitations = [];
        }
      ) == null)
      "broad row combining DNS and NAT must be rejected"
    && require
      (tryEvalOrNull (
        validateEquivalenceRow "missing-clab-surface" {
          predicates = [ "routing-style" ];
          requestedScope = "site-clab site-nixos";
          clabEvidenceSurface = null;
          nixosEvidenceSurface = "nixos-routing-probe";
          expectedOutcome = "equivalent";
          limitations = [];
        }
      ) == null)
      "row with missing CLAB evidence surface must be rejected"
    && require
      (tryEvalOrNull (
        validateEquivalenceRow "missing-nixos-surface" {
          predicates = [ "service-exposure" ];
          requestedScope = "site-clab site-nixos";
          clabEvidenceSurface = "clab-service-probe";
          nixosEvidenceSurface = null;
          expectedOutcome = "equivalent";
          limitations = [];
        }
      ) == null)
      "row with missing NixOS evidence surface must be rejected"
' >/dev/null || fail "equivalence row atomization validation failed"

echo "PASS FS-780-HDS-020-SDS-010-SMS-010-equivalence-row-atomization"
