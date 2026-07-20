#!/usr/bin/env bash
# GAMP-ID: FS-730-HDS-020-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"

fail() {
  echo "FAIL fs730-hds020-sds010-sms010-printer-service-surfaces: $*" >&2
  exit 1
}

HAT_DIR="${hat_dir}" nix eval -f - <<'NIXEOF' >/dev/null 2>&1 || fail "printer service surface records are incomplete"
let
  root = builtins.getEnv "HAT_DIR";
  nixosInv = import (root + "/inventory-nixos.nix");
  intent = import (root + "/intent.nix");
  site = intent.esp0xdeadbeef.site-a;
  clients = nixosInv.deployment.hosts.s-router-test-clients.hat.endpointClients or { };
  printer = clients.nixos-printer01 or { };
  require = cond: msg: if cond then true else throw msg;

  surfaces = printer.serviceSurfaces or { };
  ippSurface = surfaces.ipp or { };
  adminSurface = surfaces.admin or { };
in
  # ---- IPP payload endpoint surface ----
  require (builtins.hasAttr "service" ippSurface)
    "FS-730-HDS-020-SDS-010-SMS-010: IPP service surface must exist"
  && require (ippSurface.service or "" == "hat-printer-ipp")
    "FS-730-HDS-020-SDS-010-SMS-010: IPP surface must bind hat-printer-ipp service"
  && require (ippSurface.protocol or "" == "tcp")
    "FS-730-HDS-020-SDS-010-SMS-010: IPP surface must declare tcp"
  && require (ippSurface.ports or [ ] == [ 631 ])
    "FS-730-HDS-020-SDS-010-SMS-010: IPP surface must declare port 631"
  && require (builtins.hasAttr "gampId" ippSurface)
    "FS-730-HDS-020-SDS-010-SMS-010: IPP surface must carry a gampId"

  # ---- Web administration endpoint surface ----
  && require (builtins.hasAttr "service" adminSurface)
    "FS-730-HDS-020-SDS-010-SMS-010: admin service surface must exist"
  && require (adminSurface.service or "" == "hat-printer-admin")
    "FS-730-HDS-020-SDS-010-SMS-010: admin surface must bind hat-printer-admin service"
  && require (adminSurface.protocol or "" == "tcp")
    "FS-730-HDS-020-SDS-010-SMS-010: admin surface must declare tcp"
  && require (adminSurface.ports or [ ] == [ 80 ])
    "FS-730-HDS-020-SDS-010-SMS-010: admin surface must declare port 80"
  && require (builtins.hasAttr "gampId" adminSurface)
    "FS-730-HDS-020-SDS-010-SMS-010: admin surface must carry a gampId"

  # ---- CUPS service state ----
  && require (builtins.hasAttr "service" (printer.serviceState or { }))
    "FS-730-HDS-020-SDS-010-SMS-010: CUPS service-state must exist"
  && require (printer.serviceState.service or "" == "cups")
    "FS-730-HDS-020-SDS-010-SMS-010: service-state must name cups"
  && require (printer.serviceState.systemdUnit or "" == "cups.service")
    "FS-730-HDS-020-SDS-010-SMS-010: service-state must name cups.service unit"
  && require (printer.serviceState.required or false == true)
    "FS-730-HDS-020-SDS-010-SMS-010: service-state must be required"
  && require (printer.serviceState.targetState or "" == "running")
    "FS-730-HDS-020-SDS-010-SMS-010: service-state must target running"

  # ---- Persistence expectation ----
  && require (builtins.hasAttr "kind" (printer.persistenceExpectation or { }))
    "FS-730-HDS-020-SDS-010-SMS-010: persistence expectation must exist"
  && require (printer.persistenceExpectation.kind or "" == "persistent-service-state")
    "FS-730-HDS-020-SDS-010-SMS-010: persistence must be persistent-service-state"
  && require (printer.persistenceExpectation.required or false == true)
    "FS-730-HDS-020-SDS-010-SMS-010: persistence must be required"
  && require (printer.persistenceExpectation.service or "" == "cups")
    "FS-730-HDS-020-SDS-010-SMS-010: persistence must bind to cups"
  && require (printer.persistenceExpectation.paths or [ ] == [ "/var/lib/cups" ])
    "FS-730-HDS-020-SDS-010-SMS-010: persistence must name /var/lib/cups path"

  # ---- Management boundary ----
  && require (builtins.hasAttr "mode" (printer.managementBoundary or { }))
    "FS-730-HDS-020-SDS-010-SMS-010: management boundary must exist"
  && require (printer.managementBoundary.mode or "" == "declared-service-surfaces-only")
    "FS-730-HDS-020-SDS-010-SMS-010: management must be declared-service-surfaces-only"
  && require (printer.managementBoundary.fixturePlacementCreatesManagementAccess or true == false)
    "FS-730-HDS-020-SDS-010-SMS-010: fixture placement must not create management access"

  # ---- Policy-from-placement rejection (seeded negative) ----
  && require (builtins.hasAttr "mayInferPolicy" (printer.fixtureAuthority or { }))
    "FS-730-HDS-020-SDS-010-SMS-010: fixture authority must exist"
  && require (printer.fixtureAuthority.mayInferPolicy or true == false)
    "FS-730-HDS-020-SDS-010-SMS-010: NEG seeds: must not infer policy from placement (diagnostic.printer-surface-policy-inference)"
  && require (printer.fixtureAuthority.mayGrantManagementAccess or true == false)
    "FS-730-HDS-020-SDS-010-SMS-010: must not grant management access from placement"
  && require (printer.fixtureAuthority.policyAuthority or "" == "intent-communication-contract")
    "FS-730-HDS-020-SDS-010-SMS-010: policy authority must be intent-communication-contract"

  # ---- IPP endpoint completeness (seeded negative guard: diagnostic.missing-printer-ipp) ----
  && require (builtins.all (f: builtins.hasAttr f ippSurface) [
    "service" "protocol" "ports" "gampId"
  ])
    "FS-730-HDS-020-SDS-010-SMS-010: IPP surface field completeness (diagnostic.missing-printer-ipp guard)"
  && require (builtins.all (f: builtins.hasAttr f adminSurface) [
    "service" "protocol" "ports" "gampId"
  ])
    "FS-730-HDS-020-SDS-010-SMS-010: admin surface field completeness"
NIXEOF

echo "PASS fs730-hds020-sds010-sms010-printer-service-surfaces"
