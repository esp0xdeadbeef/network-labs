#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-030-SMS-020
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
# SMS-020 CMC: cpm_flake removed — downstream entrypoint reference.
# CPM compile-and-build invocations and jq validation of CPM output
# are downstream-dependent and moved to network-control-plane-model/tests/.

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL hat-upstream-inventory-realization-boundary: $*" >&2
  exit 1
}

check_inventory_expr='
  let
    root = builtins.getEnv "HAT_DIR";
    clab = import (root + "/inventory-clab.nix");
    nixos = import (root + "/inventory-nixos.nix");
    inventories = [
      { label = "clab"; value = clab; }
      { label = "nixos"; value = nixos; }
    ];
    allowedHatHosts = [ "s-router-clab" "s-router-nixos" ];
    require = cond: msg: if cond then true else throw msg;
    hasAttr = builtins.hasAttr;
    nodesWithPppoe = inventory:
      builtins.filter
        (node: hasAttr "pppoe" ((node.services or { })))
        (builtins.attrValues (inventory.realization.nodes or { }));
    pppoeRoles = node:
      builtins.filter
        (role: hasAttr role (node.services.pppoe or { }))
        [ "client" "server" ];
    roleCredentials = node: role:
      node.services.pppoe.${role}.credentials or { };
    protectedCredentialRefOk = credentials:
      (credentials.labOnly or false) == true
      && !(hasAttr "username" credentials)
      && !(hasAttr "password" credentials)
      && (credentials.usernameFile or "") == "/run/secrets/hat-pppoe-username"
      && (credentials.passwordFile or "") == "/run/secrets/hat-pppoe-password";
    nodeCredentialRefsOk = node:
      builtins.all
        (role: protectedCredentialRefOk (roleCredentials node role))
        (pppoeRoles node);
    inventoryOk = item:
      let
        inventory = item.value;
        nodes = nodesWithPppoe inventory;
      in
        require (nodes != [ ])
          "${item.label} inventory must emit PPPoE runtime realization records"
        && require (builtins.all nodeCredentialRefsOk nodes)
          "${item.label} PPPoE runtime credentials must use protected file references only"
        && require (builtins.all (node: builtins.elem (node.host or null) allowedHatHosts) nodes)
          "${item.label} PPPoE runtime realization nodes must stay bound to approved HAT hosts";
  in
    builtins.all inventoryOk inventories
'

HAT_DIR="${hat_dir}" nix eval --impure --expr "${check_inventory_expr}" >/dev/null

# SMS-020 CMC: Removed CPM compile-and-build invocations producing
# clab.json and nixos.json, and the jq validation of PPPoE credential
# references in CPM output. These validations are downstream-dependent
# and must live in network-control-plane-model/tests/.

echo "PASS hat-upstream-inventory-realization-boundary"
