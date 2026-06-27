#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
selector="${repo_root}/scripts/select-current-lab.sh"

fail() {
  echo "FAIL current-lab-selector: $*" >&2
  exit 1
}

cleanup() {
  "${selector}" default >/dev/null
}
trap cleanup EXIT

"${selector}" --list >/dev/null

"${selector}" default >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  inventory = import (repoRoot + "/active-lab/inventory-nixos.nix");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.selector == "renderer-nixos") "default current-lab selector mismatch"
  && require (active.intent.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime") "active-lab must import default current-lab intent"
  && require (inventory.activeLabInventoryStub.runtimeManagement.vlan2 == "management-only") "default selection must preserve VLAN2 management"
' >/dev/null || fail "default selection failed"

"${selector}" SMT internet-mode-verification >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  require = cond: msg: if cond then true else throw msg;
  testUplinkNames = uplinks: builtins.filter (name: name != "management") (builtins.attrNames uplinks);
  uplinksOk = uplinks:
    builtins.all
      (name:
        let uplink = uplinks.${name}; in
        (uplink.vlan == 4 || uplink.vlan == 5) && uplink.mode == "dhcp")
      (testUplinkNames uplinks);
  noTestVlan2 = uplinks:
    builtins.all (name: (uplinks.${name}.vlan or null) != 2) (testUplinkNames uplinks);
  managementOk = uplinks:
    uplinks.management.vlan == 2
    && uplinks.management.bridge == "vlan2"
    && uplinks.management.ipv4.dhcp == true
    && uplinks.management.ipv6.acceptRA == false;
  tenantBridge = "br-mini-smt-internet-mode-verification-tenant-client";
  tenantPortOk = inventory:
    inventory.realization.nodes.mini-smt-internet-mode-verification-client-edge.ports.tenant-client.logicalInterface == "tenant-client"
    && inventory.realization.nodes.mini-smt-internet-mode-verification-client-edge.ports.tenant-client.attach.kind == "bridge"
    && inventory.realization.nodes.mini-smt-internet-mode-verification-client-edge.ports.tenant-client.attach.bridge == tenantBridge
    && builtins.hasAttr tenantBridge inventory.deployment.hosts.s-router-clab.bridgeNetworks;
in
  require (current.selection.layer == "SMT") "SMT selector layer mismatch"
  && require (current.selection.selector == "internet-mode-verification") "SMT selector id mismatch"
  && require (current.selection.traceId == "FS-380-HDS-020-SDS-010-SMS-050") "SMT trace mismatch"
  && require (managementOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode must preserve VLAN2 management"
  && require (managementOk inventoryNixos.deployment.hosts.s-router-nixos.uplinks) "nixos internet-mode must expose deployment.hosts management"
  && require (inventoryNixos.realization.nodes.mini-smt-internet-mode-verification-client-edge.host == "s-router-nixos") "nixos internet-mode realization host mismatch"
  && require (uplinksOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode uplinks must be VLAN4/VLAN5 DHCP"
  && require (noTestVlan2 inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode test uplinks must not use VLAN2"
  && require (managementOk inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode must preserve VLAN2 management"
  && require (managementOk inventoryClab.deployment.hosts.s-router-clab.uplinks) "clab internet-mode must expose deployment.hosts management"
  && require (inventoryClab.realization.nodes.mini-smt-internet-mode-verification-client-edge.host == "s-router-clab") "clab internet-mode realization host mismatch"
  && require (tenantPortOk inventoryClab) "clab internet-mode tenant bridge realization missing"
  && require (uplinksOk inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode uplinks must be VLAN4/VLAN5 DHCP"
  && require (noTestVlan2 inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode test uplinks must not use VLAN2"
  && require (managementOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "test-client internet-mode must preserve VLAN2 management"
  && require (managementOk inventoryClients.deployment.hosts.s-router-test-clients.uplinks) "test-client internet-mode must expose deployment.hosts management"
  && require (inventoryClients.realization.nodes.mini-smt-internet-mode-verification-client-edge.host == "s-router-test-clients") "test-client internet-mode realization host mismatch"
  && require (uplinksOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "test-client internet-mode uplinks must be VLAN4/VLAN5 DHCP"
  && require (noTestVlan2 inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "test-client internet-mode test uplinks must not use VLAN2"
' >/dev/null || fail "SMT internet-mode selection failed"

"${selector}" SMT renderer-nixos-p2p >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.layer == "SMT") "renderer SMT selector layer mismatch"
  && require (current.selection.selector == "renderer-nixos-p2p") "renderer SMT selector id mismatch"
  && require (current.selection.traceId == "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime-p2p") "renderer SMT suffixed trace mismatch"
  && require (current.selection.sourceRoot == "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900") "renderer SMT source root must use canonical row directory"
  && require (active.intent.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime-p2p") "renderer SMT active-lab import mismatch"
' >/dev/null || fail "SMT renderer selection failed"

"${selector}" HAT >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  inventory = import (repoRoot + "/active-lab/inventory-nixos.nix");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.layer == "HAT") "HAT selector layer mismatch"
  && require (current.selection.selector == "emulated-isp-residential-testnet") "HAT selector mismatch"
  && require (inventory.deployment.hosts ? s-router-nixos) "HAT inventory must expose s-router-nixos"
' >/dev/null || fail "HAT selection failed"

"${selector}" SAT >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  inventory = import (repoRoot + "/active-lab/inventory-nixos.nix");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.layer == "SAT") "SAT selector layer mismatch"
  && require (inventory.deployment.hosts ? s-router-nixos) "SAT inventory must expose s-router-nixos"
' >/dev/null || fail "SAT selection failed"

cleanup
trap - EXIT

echo "PASS current-lab-selector"
