#!/usr/bin/env bash
# GAMP-ID: FS-790-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
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
    validateProviderBoundary = rowName: row:
      require (builtins.elem rowName expectedKeys)
        "public-ingress provider/emulation validation must reject unknown row names"
      && require (row ? externalProviderRequired)
        "${rowName} must declare externalProviderRequired explicitly"
      && require (row ? localEmulationAllowed)
        "${rowName} must declare localEmulationAllowed explicitly"
      && require (row.externalProviderRequired == true)
        "${rowName} externalProviderRequired must stay true"
      && require (row.localEmulationAllowed == false)
        "${rowName} localEmulationAllowed must stay false"
      && require (row ? protocol && row ? publicPort && row ? targetService && row ? targetEndpoint && row ? targetPort)
        "${rowName} provider/emulation facts must not create exposure policy without explicit port/target binding";
    expectValidationFailure = rowName: row: msg:
      require (!(builtins.tryEval (validateProviderBoundary rowName row)).success) msg;
  in
    require (builtins.attrNames fixtureTable == expectedKeys)
      "public-ingress provider/emulation proof must cover every controlled public ingress row"
    && validateProviderBoundary "site-clab-tcp-4445" fixtureTable.site-clab-tcp-4445
    && validateProviderBoundary "site-clab-udp-4445" fixtureTable.site-clab-udp-4445
    && validateProviderBoundary "site-hetz-tcp-4446" fixtureTable.site-hetz-tcp-4446
    && validateProviderBoundary "site-hetz-udp-4446" fixtureTable.site-hetz-udp-4446
    && validateProviderBoundary "site-nixos-tcp-4444" fixtureTable.site-nixos-tcp-4444
    && validateProviderBoundary "site-nixos-udp-4444" fixtureTable.site-nixos-udp-4444
    && expectValidationFailure "site-clab-tcp-4445" {
      site = "site-clab";
      externalProviderRequired = true;
      localEmulationAllowed = false;
    }
      "public-ingress provider/emulation facts must not authorize exposure without the explicit port/target contract"
    && expectValidationFailure "site-hetz-tcp-4446" (fixtureTable.site-hetz-tcp-4446 // {
      externalProviderRequired = false;
    })
      "public-ingress provider/emulation validation must reject rows that drop the external provider requirement"
    && expectValidationFailure "site-hetz-udp-4446" (fixtureTable.site-hetz-udp-4446 // {
      localEmulationAllowed = true;
    })
      "public-ingress provider/emulation validation must reject rows that let local emulation create exposure policy"
' >/dev/null

echo "PASS s-sigma-public-ingress-provider-emulation-boundary"
