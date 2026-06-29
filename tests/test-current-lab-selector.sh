#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
selector="${repo_root}/scripts/select-current-lab.sh"
current_dir="${repo_root}/current-lab"
restore_dir="$(mktemp -d)"

cp -a "${current_dir}/." "${restore_dir}/"

fail() {
  echo "FAIL current-lab-selector: $*" >&2
  exit 1
}

cleanup() {
  cp -a "${restore_dir}/." "${current_dir}/"
  rm -rf "${restore_dir}"
}
trap cleanup EXIT

"${selector}" --list >/dev/null

"${selector}" --list | rg -qx 'SIT FS-500-HDS-010-SDS-010' \
  || fail "selector list must include current runnable SIT FS-500-HDS-010-SDS-010"
if "${selector}" --list | rg -qx 'SIT FS-010-HDS-010-SDS-010'; then
  fail "selector list must not expose source-stub-only SIT FS-010-HDS-010-SDS-010"
fi

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
        (uplink.vlan == 4 || uplink.vlan == 5)
        && uplink.mode == "vlan"
        && uplink.ipv4.method == "dhcp"
        && uplink.ipv4.dhcp == true)
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
  && require (uplinksOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode uplinks must be VLAN4/VLAN5 links with DHCP addressing"
  && require (noTestVlan2 inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode test uplinks must not use VLAN2"
  && require (managementOk inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode must preserve VLAN2 management"
  && require (managementOk inventoryClab.deployment.hosts.s-router-clab.uplinks) "clab internet-mode must expose deployment.hosts management"
  && require (inventoryClab.realization.nodes.mini-smt-internet-mode-verification-client-edge.host == "s-router-clab") "clab internet-mode realization host mismatch"
  && require (tenantPortOk inventoryClab) "clab internet-mode tenant bridge realization missing"
  && require (uplinksOk inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode uplinks must be VLAN4/VLAN5 links with DHCP addressing"
  && require (noTestVlan2 inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode test uplinks must not use VLAN2"
  && require (managementOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "test-client internet-mode must preserve VLAN2 management"
  && require (managementOk inventoryClients.deployment.hosts.s-router-test-clients.uplinks) "test-client internet-mode must expose deployment.hosts management"
  && require (inventoryClients.realization.nodes.mini-smt-internet-mode-verification-client-edge.host == "s-router-test-clients") "test-client internet-mode realization host mismatch"
  && require (uplinksOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "test-client internet-mode uplinks must be VLAN4/VLAN5 links with DHCP addressing"
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

"${selector}" SMT renderer-clab >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.layer == "SMT") "renderer-clab selector layer mismatch"
  && require (current.selection.selector == "renderer-clab") "renderer-clab selector id mismatch"
  && require (current.selection.traceId == "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-clab") "renderer-clab trace mismatch"
  && require (current.selection.sourcePath == "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix") "renderer-clab source path mismatch"
  && require (active.intent.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime") "renderer-clab must preserve the global NixOS runtime CPM"
  && require (inventoryNixos.activeLabInventoryStub.miniSmtId == "renderer-nixos") "renderer-clab must preserve NixOS inventory shim"
  && require (inventoryNixos.activeLabInventoryStub.runtimeManagement.vlan2 == "management-only") "renderer-clab must preserve NixOS management metadata"
  && require (inventoryClab.activeLabInventoryStub.miniSmtId == "renderer-clab") "renderer-clab must preserve CLAB provenance shim"
  && require (inventoryClab.deploymentHosts ? s-router-clab) "renderer-clab CLAB inventory must expose s-router-clab"
' >/dev/null || fail "SMT renderer-clab selection failed"

"${selector}" SIT FS-500-HDS-010-SDS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.layer == "SIT") "SIT selector layer mismatch"
  && require (current.selection.selector == "FS-500-HDS-010-SDS-010") "SIT selector id mismatch"
  && require (current.selection.sourceRoot == "GAMP/SIT/FS-500-HDS-010-SDS-010") "SIT source root mismatch"
  && require (current.selection.sourcePath == "GAMP/SIT/FS-500-HDS-010-SDS-010/default.nix") "SIT source path mismatch"
  && require (active.intent ? "mini-smt") "SIT selection must install the row-local mini-SMT source"
  && require (active.intent."mini-smt" ? "reachability-decision") "SIT FS-500 must select its first registered mini-SMT source"
  && require (inventoryNixos.deploymentHosts ? s-router-nixos) "SIT selection must install runnable NixOS inventory"
' >/dev/null || fail "SIT selection failed"

"${selector}" SIT FS-540-HDS-010-SDS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  require = cond: msg: if cond then true else throw msg;
  expectedNodes = [
    "mini-smt-dns-resolver-config-access-dns"
    "mini-smt-dns-resolver-config-downstream-selector"
    "mini-smt-dns-resolver-config-policy"
    "mini-smt-dns-resolver-config-resolver-node"
    "mini-smt-dns-resolver-config-upstream-selector"
  ];
  nixosNodes = builtins.attrNames inventoryNixos.realization.nodes;
  clabNodes = builtins.attrNames inventoryClab.realization.nodes;
  nixosUplinks = inventoryNixos.deploymentHosts.s-router-nixos.uplinks;
  clabUplinks = inventoryClab.deploymentHosts.s-router-clab.uplinks;
in
  require (current.selection.layer == "SIT") "FS-540 SIT selector layer mismatch"
  && require (current.selection.selector == "FS-540-HDS-010-SDS-010") "FS-540 SIT selector id mismatch"
  && require (current.selection.sourceRoot == "GAMP/SIT/FS-540-HDS-010-SDS-010") "FS-540 SIT source root mismatch"
  && require (active.intent ? "mini-smt") "FS-540 SIT selection must install the row-local mini-SMT source"
  && require (active.intent."mini-smt" ? "dns-resolver-config") "FS-540 SIT must select the DNS resolver mini source"
  && require (manifest.tests.dns-resolver-config.maxRuntimeTargets == 5) "FS-540 DNS resolver mini cap must be five targets"
  && require (nixosNodes == expectedNodes) "FS-540 NixOS SIT must realize exactly the five-node DNS mini path"
  && require (clabNodes == expectedNodes) "FS-540 CLAB SIT must realize exactly the five-node DNS mini path"
  && require (builtins.all (name: inventoryNixos.realization.nodes.${name}.host == "s-router-nixos") nixosNodes) "FS-540 NixOS mini nodes must stay on s-router-nixos"
  && require (builtins.all (name: inventoryClab.realization.nodes.${name}.host == "s-router-clab") clabNodes) "FS-540 CLAB mini nodes must stay on s-router-clab"
  && require (nixosUplinks ? testnet-vlan4 && nixosUplinks.testnet-vlan4.vlan == 4 && nixosUplinks.testnet-vlan4.mode == "vlan" && nixosUplinks.testnet-vlan4.ipv4.method == "dhcp") "FS-540 NixOS mini uplink must be explicit VLAN4 link with DHCP addressing, not untagged testnet"
  && require (clabUplinks ? testnet-vlan4 && clabUplinks.testnet-vlan4.vlan == 4 && clabUplinks.testnet-vlan4.mode == "vlan" && clabUplinks.testnet-vlan4.ipv4.method == "dhcp") "FS-540 CLAB mini uplink must be explicit VLAN4 link with DHCP addressing, not untagged testnet"
' >/dev/null || fail "SIT FS-540 selection failed"

if "${selector}" SIT FS-010-HDS-010-SDS-010 >/dev/null 2>&1; then
  fail "source-stub-only SIT selection should fail"
fi

"${selector}" HAT >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  clients = import (repoRoot + "/active-lab/clients.nix");
  inventory = import (repoRoot + "/active-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/active-lab/inventory-clab.nix");
  requiredNixosClients = [
    "nixos-branch-node01"
    "nixos-client01"
    "nixos-client02"
    "nixos-emulated-sigma"
    "nixos-printer01"
    "nixos-receiver01"
    "nixos-streaming-test"
  ];
  requiredClabClients = [
    "clab-client01"
    "clab-client02"
    "clab-emulated-sigma"
  ];
  require = cond: msg: if cond then true else throw msg;
  sorted = builtins.sort (a: b: a < b);
in
  require (current.selection.layer == "HAT") "HAT selector layer mismatch"
  && require (current.selection.selector == "emulated-isp-residential-testnet") "HAT selector mismatch"
  && require (current.selection.sourceRoot == "GAMP/HAT/emulated-isp-residential-testnet") "HAT source root mismatch"
  && require (toString active.sourcePaths.sops == repoRoot + "/active-lab/sops.nix") "active-lab must expose the selected HAT sops module"
  && require (clients.activeLabClientStub.kind == "hat-client-source") "HAT clients must be a real selected client source, not an empty compatibility stub"
  && require (sorted clients.requiredEndpointClients == requiredNixosClients) "HAT required NixOS clients mismatch"
  && require (sorted (builtins.attrNames clients.clients) == requiredNixosClients) "HAT clients.nix must expose every required NixOS endpoint"
  && require (inventory.deployment.hosts ? s-router-nixos) "HAT inventory must expose s-router-nixos"
  && require (inventory.deployment.hosts ? s-router-test-clients) "HAT inventory must expose s-router-test-clients"
  && require (sorted inventory.deployment.hosts.s-router-test-clients.hat.requiredEndpointClients == requiredNixosClients) "HAT inventory required NixOS endpoint list mismatch"
  && require (sorted (builtins.attrNames inventory.deployment.hosts.s-router-test-clients.hat.endpointClients) == requiredNixosClients) "HAT inventory must define all NixOS endpoint clients"
  && require (sorted inventoryClab.deployment.hosts.s-router-clab.hat.requiredEndpointClients == requiredClabClients) "HAT CLAB required endpoint list mismatch"
  && require (sorted (builtins.attrNames inventoryClab.deployment.hosts.s-router-clab.hat.endpointClients) == requiredClabClients) "HAT CLAB inventory must define all CLAB endpoint fixtures"
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
