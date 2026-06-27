#!/usr/bin/env bash
# GAMP-ID: FS-790-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --impure --expr '
  let
    fixtureTable = import '"${lab_dir}"'/public-ingress-fixture-table.nix;
    require = cond: msg: if cond then true else throw msg;
    expectedKeys = [
      "site-clab-tcp-4445"
      "site-clab-udp-4445"
      "site-hetz-tcp-4446"
      "site-hetz-udp-4446"
      "site-nixos-tcp-4444"
      "site-nixos-udp-4444"
    ];
    expectedDeniedVariants = builtins.listToAttrs (builtins.map
      (name: {
        inherit name;
        value = [
          "wrong-source-scope"
          "wrong-protocol"
          "wrong-port"
          "wrong-target"
          "missing-return-path"
        ];
      })
      expectedKeys);
    validateDeniedVariants = rowName: row:
      require (builtins.hasAttr rowName expectedDeniedVariants)
        "public-ingress denied-variant validation must reject unknown row names"
      && require (row ? deniedVariants)
        "${rowName} must declare deniedVariants explicitly"
      && require (row.deniedVariants == builtins.getAttr rowName expectedDeniedVariants)
        "${rowName} deniedVariants must stay row-scoped and exact";
    expectValidationFailure = rowName: row: msg:
      require (!(builtins.tryEval (validateDeniedVariants rowName row)).success) msg;
  in
    require (builtins.attrNames fixtureTable == expectedKeys)
      "public-ingress denied-variant proof must cover every controlled public ingress row"
    && validateDeniedVariants "site-clab-tcp-4445" fixtureTable.site-clab-tcp-4445
    && validateDeniedVariants "site-clab-udp-4445" fixtureTable.site-clab-udp-4445
    && validateDeniedVariants "site-hetz-tcp-4446" fixtureTable.site-hetz-tcp-4446
    && validateDeniedVariants "site-hetz-udp-4446" fixtureTable.site-hetz-udp-4446
    && validateDeniedVariants "site-nixos-tcp-4444" fixtureTable.site-nixos-tcp-4444
    && validateDeniedVariants "site-nixos-udp-4444" fixtureTable.site-nixos-udp-4444
    && expectValidationFailure "site-nixos-tcp-4444" (fixtureTable.site-nixos-tcp-4444 // {
      deniedVariants = [
        "wrong-source-scope"
        "wrong-protocol"
        "wrong-port"
        "wrong-target"
      ];
    })
      "public-ingress denied-variant validation must reject rows that omit required denied variants"
    && expectValidationFailure "site-hetz-tcp-4446" (fixtureTable.site-hetz-tcp-4446 // {
      deniedVariants = [
        "wrong-source-scope"
        "wrong-protocol"
        "wrong-port"
        "wrong-target"
        "missing-return-path"
        "wildcard-anything"
      ];
    })
      "public-ingress denied-variant validation must reject overbroad denial summaries"
' >/dev/null

echo "PASS s-sigma-public-ingress-denied-variants"
