#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"

fail() {
  echo "FAIL fs730-printer-cups-source: $*" >&2
  exit 1
}

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    intent = import (root + "/intent.nix");
    nixos = import (root + "/inventory-nixos.nix");
    site = intent.esp0xdeadbeef.site-a;
    clients = nixos.deployment.hosts.s-router-test-clients.hat.endpointClients or { };
    printer = clients.nixos-printer01 or { };
    services = builtins.listToAttrs (
      map (service: { name = service.name; value = service; })
        (site.communicationContract.services or [ ])
    );
    trafficTypes = builtins.listToAttrs (
      map (trafficType: { name = trafficType.name; value = trafficType; })
        (site.communicationContract.trafficTypes or [ ])
    );
    require = cond: msg: if cond then true else throw msg;
    trafficTypeHasPort = name: proto: port:
      builtins.any
        (match: (match.proto or null) == proto && builtins.elem port (match.dports or [ ]))
        (trafficTypes.${name}.match or [ ]);
    surface = name: (printer.serviceSurfaces or { }).${name} or { };
  in
    require (builtins.hasAttr "nixos-printer01" clients)
      "FS-730 printer source must declare the NixOS printer endpoint"
    && require (printer.gampId == "FS-730-HDS-010-SDS-010-SMS-010")
      "FS-730 SMS-010 must own the printer endpoint source record"
    && require (printer.vm.gampId == "FS-730-HDS-010-SDS-010-SMS-010")
      "FS-730 SMS-010 must identify the printer as a NixOS VM"
    && require (printer.vm.kind == "nixos-vm" && printer.vm.role == "cups-printer" && printer.vm.service == "cups")
      "FS-730 SMS-010 must declare NixOS VM/CUPS printer semantics"
    && require ((services.hat-printer-ipp.providers or [ ]) == [ "nixos-printer01" ])
      "FS-730 intent must bind IPP service to nixos-printer01"
    && require ((services.hat-printer-admin.providers or [ ]) == [ "nixos-printer01" ])
      "FS-730 intent must bind admin service to nixos-printer01"
    && require (trafficTypeHasPort "ipp" "tcp" 631)
      "FS-730 intent must model IPP tcp/631"
    && require (trafficTypeHasPort "printer-admin" "tcp" 80)
      "FS-730 intent must model printer admin tcp/80"
    && require ((surface "ipp").service == "hat-printer-ipp" && (surface "ipp").protocol == "tcp" && (surface "ipp").ports == [ 631 ])
      "FS-730 inventory must bind the IPP surface one-to-one"
    && require ((surface "admin").service == "hat-printer-admin" && (surface "admin").protocol == "tcp" && (surface "admin").ports == [ 80 ])
      "FS-730 inventory must bind the admin surface one-to-one"
    && require (printer.serviceState.gampId == "FS-730-HDS-010-SDS-010-SMS-020")
      "FS-730 SMS-020 must own CUPS service-state semantics"
    && require (printer.serviceState.service == "cups" && printer.serviceState.systemdUnit == "cups.service")
      "FS-730 SMS-020 must name the CUPS service and unit"
    && require (printer.serviceState.required == true && printer.serviceState.targetState == "running")
      "FS-730 SMS-020 must require running CUPS state"
    && require (printer.persistenceExpectation.gampId == "FS-730-HDS-010-SDS-010-SMS-030")
      "FS-730 SMS-030 must own CUPS persistence semantics"
    && require (printer.persistenceExpectation.kind == "persistent-service-state")
      "FS-730 SMS-030 must require persistent service state"
    && require (printer.persistenceExpectation.required == true && printer.persistenceExpectation.service == "cups")
      "FS-730 SMS-030 must bind persistence to CUPS"
    && require (printer.persistenceExpectation.paths == [ "/var/lib/cups" ])
      "FS-730 SMS-030 must name the CUPS state path"
    && require (printer.fixtureAuthority.gampId == "FS-730-HDS-010-SDS-010-SMS-030")
      "FS-730 SMS-030 must own the printer non-authority contract"
    && require (printer.fixtureAuthority.mayInferPolicy == false)
      "FS-730 source must not authorize inferred policy from printer placement"
    && require (printer.fixtureAuthority.mayGrantManagementAccess == false)
      "FS-730 source must not grant management access from printer placement"
    && require (printer.fixtureAuthority.policyAuthority == "intent-communication-contract")
      "FS-730 source must leave policy authority in intent"
' >/dev/null || fail "printer CUPS source atoms are incomplete"

echo "PASS fs730-printer-cups-source"
