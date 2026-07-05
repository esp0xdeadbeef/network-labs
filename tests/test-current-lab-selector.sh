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

selector_list="$("${selector}" --list)"

grep -Fxq 'SIT FS-500-HDS-010-SDS-010' <<<"${selector_list}" \
  || fail "selector list must include current runnable SIT FS-500-HDS-010-SDS-010"
grep -Fxq 'SIT FS-010-HDS-010-SDS-010' <<<"${selector_list}" \
  || fail "selector list must expose manifest-backed SIT FS-010-HDS-010-SDS-010"

"${selector}" default >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  inventory = import (repoRoot + "/active-lab/inventory-nixos.nix");
  inventoryHost = import (repoRoot + "/active-lab/inventory-s-router-nixos.nix");
  sopsNixos = import (repoRoot + "/active-lab/sops-routing-s-router-nixos.nix");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.selector == "FS-166-HDS-010-SDS-010-SMS-901") "default current-lab selector mismatch"
  && require (active.intent.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-901") "active-lab must import default current-lab intent"
  && require (activeIntentNixos.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-901") "default s-router-nixos host intent must import default renderer-nixos CPM"
  && require (activeIntentClab.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-901") "default s-router-clab host intent must carry the default trace"
  && require (activeIntentClab.control_plane_model.data.active-lab.clab.runtimeTargets == { }) "default s-router-clab host intent must be no-runtime for renderer-nixos"
  && require (activeIntentClab.control_plane_model.deployment.hosts ? s-router-clab) "default s-router-clab host intent must keep host substrate"
  && require (activeIntentClients.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-901") "default s-router-test-clients host intent must carry the default trace"
  && require (activeIntentClients.control_plane_model.data.active-lab.test-clients.runtimeTargets == { }) "default s-router-test-clients host intent must be no-runtime for renderer-nixos"
  && require (activeIntentClients.control_plane_model.deployment.hosts ? s-router-test-clients) "default s-router-test-clients host intent must keep host substrate"
  && require (inventory.activeLabInventoryStub.runtimeManagement.vlan2 == "management-only") "default selection must preserve VLAN2 management"
  && require (inventoryHost.activeLabInventoryStub.runtimeManagement.vlan2 == "management-only") "default host-specific NixOS inventory alias must preserve VLAN2 management"
  && require (sopsNixos.sops.secrets ? "hat-pppoe-username") "default s-router-nixos SOPS routing must expose the HAT PPPoE username secret"
  && require (sopsNixos.sops.secrets ? "hat-pppoe-password") "default s-router-nixos SOPS routing must expose the HAT PPPoE password secret"
  && require (sopsNixos.sops.secrets ? "hetzner-public-ipv4") "default s-router-nixos SOPS routing must expose HAT public runtime facts"
  && require (builtins.match ".*GAMP/HAT/emulated-isp-residential-testnet/secrets/sops-s-router-nixos.yaml" (toString sopsNixos.sops.secrets."hat-pppoe-username".sopsFile) != null) "default s-router-nixos PPPoE username must come from the HAT s-router-nixos SOPS file"
  && require (builtins.match ".*GAMP/HAT/emulated-isp-residential-testnet/secrets/sops-s-router-nixos.yaml" (toString sopsNixos.sops.secrets."hetzner-public-ipv4".sopsFile) != null) "default s-router-nixos public runtime facts must come from the HAT s-router-nixos SOPS file"
' >/dev/null || fail "default selection failed"

"${selector}" SMT FS-050-HDS-010-SDS-010-SMS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  cpmLib = (builtins.getFlake ("path:" + repoRoot + "/../network-control-plane-model")).libBySystem.${builtins.currentSystem};
  built = cpmLib.compileAndBuildFromPaths {
    inputPath = repoRoot + "/current-lab/intent-s-router-nixos.nix";
    inventoryPath = repoRoot + "/current-lab/inventory-s-router-nixos.nix";
  };
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.selector == "FS-050-HDS-010-SDS-010-SMS-010") "construction-only selector mismatch"
  && require (current.selection.sourceKind == "construction-only") "construction-only source kind mismatch"
  && require (current.intent.control_plane_model.meta.traceId == "FS-050-HDS-010-SDS-010-SMS-010") "construction-only current intent must keep full trace"
  && require (current.intent.control_plane_model.meta.evidenceBoundary == "construction-only") "construction-only current intent must keep evidence boundary"
  && require (current.intent.control_plane_model.data.active-lab.construction-only.runtimeTargets == { }) "construction-only current intent must not define runtime targets"
  && require (activeIntentNixos.control_plane_model.meta.traceId == "FS-050-HDS-010-SDS-010-SMS-010") "construction-only active host intent must keep full trace"
  && require (inventoryNixos.deploymentHosts ? s-router-nixos) "construction-only NixOS inventory must evaluate deploymentHosts"
  && require (inventoryClab.deploymentHosts ? s-router-clab) "construction-only clab inventory must evaluate deploymentHosts"
  && require (inventoryClients.deploymentHosts ? s-router-test-clients) "construction-only test-client inventory must evaluate deploymentHosts"
  && require (built.control_plane_model.meta.traceId == "FS-050-HDS-010-SDS-010-SMS-010") "construction-only CPM pass-through must keep full trace"
  && require (built.control_plane_model.meta.evidenceBoundary == "construction-only") "construction-only CPM pass-through must keep boundary"
  && require (built.control_plane_model.data.active-lab.construction-only.runtimeTargets == { }) "construction-only CPM pass-through must keep empty runtime target set"
' >/dev/null || fail "construction-only selection failed"

"${selector}" SMT FS-380-HDS-020-SDS-010-SMS-050 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  activeInventoryNixos = import (repoRoot + "/active-lab/inventory-s-router-nixos.nix");
  activeInventoryClab = import (repoRoot + "/active-lab/inventory-s-router-clab.nix");
  activeInventoryClients = import (repoRoot + "/active-lab/inventory-s-router-test-clients.nix");
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
  internetModeNode = "mini-smt-FS-380-HDS-020-SDS-010-SMS-050-client-edge";
  tenantBridge = "br-mini-smt-FS-380-HDS-020-SDS-010-SMS-050-tenant-client";
  tenantPortOk = inventory:
    inventory.realization.nodes.${internetModeNode}.ports.tenant-client.logicalInterface == "tenant-client"
    && inventory.realization.nodes.${internetModeNode}.ports.tenant-client.attach.kind == "bridge"
    && inventory.realization.nodes.${internetModeNode}.ports.tenant-client.attach.bridge == tenantBridge
    && builtins.hasAttr tenantBridge inventory.deployment.hosts.s-router-clab.bridgeNetworks;
  noRealizationNodes = inventory: ((inventory.realization or { }).nodes or { }) == { };
  noEndpointClientIntent = intent:
    ((intent.control_plane_model.data.active-lab.test-clients.runtimeTargets or { }) == { })
    && ((intent.control_plane_model.data.active-lab.test-clients.endpointAssignment or { }) == { });
  noRouterRealizationIntent = intent:
    ((intent.control_plane_model.realization or { }).nodes or { }) == { };
  handoffOk = host:
    (host.accessHandoff.kind or null) == "pppoe"
    && (host.accessHandoff.server or null) == "emulated-isp";
  clabProvider = builtins.head inventoryClab.containerlab.labEmulation.requests;
in
  require (current.selection.layer == "SMT") "SMT selector layer mismatch"
  && require (current.selection.selector == "FS-380-HDS-020-SDS-010-SMS-050") "SMT selector id mismatch"
  && require (current.selection.traceId == "FS-380-HDS-020-SDS-010-SMS-050") "SMT trace mismatch"
  && require (activeIntentNixos == activeIntentClab) "internet-mode router host-specific intent aliases must share the selected row intent"
  && require (noEndpointClientIntent activeIntentClients) "SMT/SIT test-client host-specific intent must be a CPM-shaped no-endpoint client source unless the row overrides it"
  && require (activeIntentClients.control_plane_model.deployment.hosts ? s-router-test-clients) "SMT/SIT test-client host-specific intent must keep the s-router-test-clients host substrate"
  && require (handoffOk activeIntentClients.control_plane_model.deployment.hosts.s-router-test-clients) "SMT/SIT test-client host-specific intent must preserve the row-local PPPoE handoff"
  && require (noRouterRealizationIntent activeIntentClients) "SMT/SIT test-client host-specific intent must not synthesize router realization nodes"
  && require (managementOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode must preserve VLAN2 management"
  && require (managementOk activeInventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos host-specific inventory alias must preserve VLAN2 management"
  && require (!(activeInventoryNixos.deploymentHosts ? s-router-test-clients)) "SMT/SIT NixOS host-specific inventory must not share test-client deployment host data"
  && require (managementOk inventoryNixos.deployment.hosts.s-router-nixos.uplinks) "nixos internet-mode must expose deployment.hosts management"
  && require (inventoryNixos.realization.nodes.${internetModeNode}.host == "s-router-nixos") "nixos internet-mode realization host mismatch"
  && require (uplinksOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode uplinks must be VLAN4/VLAN5 links with DHCP addressing"
  && require (noTestVlan2 inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode test uplinks must not use VLAN2"
  && require (managementOk inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode must preserve VLAN2 management"
  && require (managementOk activeInventoryClab.deploymentHosts.s-router-clab.uplinks) "clab host-specific inventory alias must preserve VLAN2 management"
  && require (managementOk inventoryClab.deployment.hosts.s-router-clab.uplinks) "clab internet-mode must expose deployment.hosts management"
  && require (inventoryClab.realization.nodes.${internetModeNode}.host == "s-router-clab") "clab internet-mode realization host mismatch"
  && require (tenantPortOk inventoryClab) "clab internet-mode tenant bridge realization missing"
  && require (uplinksOk inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode uplinks must be VLAN4/VLAN5 links with DHCP addressing"
  && require (noTestVlan2 inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode test uplinks must not use VLAN2"
  && require (inventoryClab.containerlab.capabilities.labEmulation == true) "clab internet-mode must preserve explicit lab-emulation capability"
  && require (inventoryClab.containerlab.labEmulation.scope == "harness") "clab internet-mode provider emulation must remain harness-scoped"
  && require (clabProvider.providerEmulationMode == "fake-provider" && clabProvider.handoffVlan == 11 && clabProvider.liveUpstreamVlan == 4) "clab internet-mode must preserve fake-provider VLAN11 handoff with VLAN4 live upstream"
  && require (clabProvider.dhcp4.address == "10.20.0.1/24" && clabProvider.dhcp4.router == "10.20.0.1" && clabProvider.dhcp4.clientAddress == "10.20.0.20" && clabProvider.dhcp4.rangeStart == "10.20.0.20" && clabProvider.dhcp4.rangeEnd == "10.20.0.99" && clabProvider.dhcp4.leaseTime == "5m" && clabProvider.dhcp4.sourcePrefix == "10.20.0.0/24") "clab internet-mode fake provider must declare explicit DHCPv4 service parameters"
  && require (clabProvider.nat44.enabled == true && clabProvider.nat44.sourcePrefix == "10.20.0.0/24") "clab internet-mode fake provider must declare explicit NAT44 source prefix"
  && require (clabProvider.handoffVlan != 2 && clabProvider.liveUpstreamVlan != 2) "clab internet-mode provider emulation must not use VLAN2"
  && require (inventoryClients.deploymentHosts ? s-router-test-clients) "SMT/SIT test-client inventory must keep s-router-test-clients host substrate"
  && require (activeInventoryClients == inventoryClients) "SMT/SIT test-client host-specific inventory alias must preserve the row-local client inventory"
  && require ((import (repoRoot + "/active-lab/clients-s-router-test-clients.nix")) == inventoryClients) "SMT/SIT test-client clients alias must preserve the row-local client inventory when no row clients.nix exists"
  && require (noRealizationNodes inventoryClients) "SMT/SIT test-client inventory must not synthesize router realization nodes"
  && require (noRealizationNodes activeInventoryClients) "SMT/SIT test-client host-specific inventory must not synthesize router realization nodes"
  && require (managementOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "test-client internet-mode host substrate must preserve VLAN2 management"
  && require (managementOk activeInventoryClients.deploymentHosts.s-router-test-clients.uplinks) "test-client host-specific inventory alias must preserve VLAN2 management"
  && require (uplinksOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "test-client internet-mode host substrate must expose VLAN4/VLAN5 links with DHCP addressing"
  && require (noTestVlan2 inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "test-client internet-mode host substrate must not use VLAN2 as dataplane"
' >/dev/null || fail "SMT internet-mode selection failed"

"${selector}" SMT FS-010-HDS-010-SDS-010-SMS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  activeInventoryNixos = import (repoRoot + "/active-lab/inventory-s-router-nixos.nix");
  activeInventoryClab = import (repoRoot + "/active-lab/inventory-s-router-clab.nix");
  activeInventoryClients = import (repoRoot + "/active-lab/inventory-s-router-test-clients.nix");
  require = cond: msg: if cond then true else throw msg;
  sorted = builtins.sort (left: right: left < right);
  names = attrs: sorted (builtins.attrNames attrs);
  expectedNodes = [
    "mini-smt-FS-010-HDS-010-SDS-010-SMS-010-client-edge"
    "mini-smt-FS-010-HDS-010-SDS-010-SMS-010-downstream-selector"
    "mini-smt-FS-010-HDS-010-SDS-010-SMS-010-policy"
    "mini-smt-FS-010-HDS-010-SDS-010-SMS-010-vlan4-client-dhcp-slaac"
    "mini-smt-FS-010-HDS-010-SDS-010-SMS-010-upstream-selector"
  ];
  noRealizationNodes = inventory: (((inventory.realization or { }).nodes or { }) == { });
  noEndpointClientIntent = intent:
    ((intent.control_plane_model.data.active-lab.test-clients.runtimeTargets or { }) == { })
    && ((intent.control_plane_model.data.active-lab.test-clients.endpointAssignment or { }) == { });
  managementOk = uplinks:
    uplinks.management.vlan == 2
    && uplinks.management.bridge == "vlan2"
    && uplinks.management.ipv4.dhcp == true
    && uplinks.management.ipv6.acceptRA == false;
  rowSourceOk = intent:
    intent ? mini-smt
    && intent.mini-smt ? "FS-010-HDS-010-SDS-010-SMS-010"
    && builtins.any
      (relation: relation.id == "FS-010-HDS-010-SDS-010-SMS-010__mini-verify")
      intent.mini-smt."FS-010-HDS-010-SDS-010-SMS-010".communicationContract.relations;
in
  require (current.selection.layer == "SMT") "FS-010 accepted-source-set SMT selector layer mismatch"
  && require (current.selection.selector == "FS-010-HDS-010-SDS-010-SMS-010") "FS-010 accepted-source-set SMT selector id mismatch"
  && require (current.selection.traceId == "FS-010-HDS-010-SDS-010-SMS-010") "FS-010 accepted-source-set SMT trace mismatch"
  && require (names inventoryNixos.realization.nodes == expectedNodes) "FS-010 accepted-source-set NixOS inventory must realize exactly the five-node mini path"
  && require (names inventoryClab.realization.nodes == expectedNodes) "FS-010 accepted-source-set CLAB inventory must realize exactly the five-node mini path"
  && require (noRealizationNodes inventoryClients) "FS-010 accepted-source-set test-client inventory must not realize router nodes"
  && require (names inventoryNixos.deploymentHosts == [ "s-router-nixos" ]) "FS-010 accepted-source-set NixOS inventory must only expose s-router-nixos"
  && require (names inventoryClab.deploymentHosts == [ "s-router-clab" ]) "FS-010 accepted-source-set CLAB inventory must only expose s-router-clab"
  && require (names inventoryClients.deploymentHosts == [ "s-router-test-clients" ]) "FS-010 accepted-source-set test-client inventory must only expose s-router-test-clients"
  && require (builtins.all (name: inventoryNixos.realization.nodes.${name}.host == "s-router-nixos") expectedNodes) "FS-010 accepted-source-set NixOS mini nodes must stay on s-router-nixos"
  && require (builtins.all (name: inventoryClab.realization.nodes.${name}.host == "s-router-clab") expectedNodes) "FS-010 accepted-source-set CLAB mini nodes must stay on s-router-clab"
  && require (activeIntentNixos == activeIntentClab) "FS-010 accepted-source-set router host-specific intent aliases must share the selected row intent"
  && require (rowSourceOk activeIntentNixos) "FS-010 accepted-source-set router host-specific intent must preserve the row mini-smt source"
  && require (noEndpointClientIntent activeIntentClients) "FS-010 accepted-source-set test-client host-specific intent must be a no-endpoint source"
  && require (activeIntentClients.control_plane_model.deployment.hosts ? s-router-test-clients) "FS-010 accepted-source-set test-client host-specific intent must keep s-router-test-clients"
  && require (activeInventoryNixos == inventoryNixos) "FS-010 accepted-source-set s-router-nixos inventory alias must preserve the selected row inventory"
  && require (activeInventoryClab == inventoryClab) "FS-010 accepted-source-set s-router-clab inventory alias must preserve the selected row inventory"
  && require (activeInventoryClients == inventoryClients) "FS-010 accepted-source-set s-router-test-clients inventory alias must preserve the selected row inventory"
  && require ((import (repoRoot + "/active-lab/clients-s-router-test-clients.nix")) == inventoryClients) "FS-010 accepted-source-set clients alias must preserve the no-router client inventory"
  && require (managementOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "FS-010 accepted-source-set NixOS inventory must preserve VLAN2 management"
  && require (managementOk inventoryClab.deploymentHosts.s-router-clab.uplinks) "FS-010 accepted-source-set CLAB inventory must preserve VLAN2 management"
  && require (managementOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "FS-010 accepted-source-set test-client inventory must preserve VLAN2 management"
' >/dev/null || fail "SMT FS-010-HDS-010-SDS-010-SMS-010 selection failed"

"${selector}" SMT FS-020-HDS-010-SDS-010-SMS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  activeInventoryNixos = import (repoRoot + "/active-lab/inventory-s-router-nixos.nix");
  activeInventoryClab = import (repoRoot + "/active-lab/inventory-s-router-clab.nix");
  activeInventoryClients = import (repoRoot + "/active-lab/inventory-s-router-test-clients.nix");
  require = cond: msg: if cond then true else throw msg;
  sorted = builtins.sort (left: right: left < right);
  names = attrs: sorted (builtins.attrNames attrs);
  expectedNodes = [
    "mini-smt-FS-020-HDS-010-SDS-010-SMS-010-client-edge"
    "mini-smt-FS-020-HDS-010-SDS-010-SMS-010-downstream-selector"
    "mini-smt-FS-020-HDS-010-SDS-010-SMS-010-policy"
    "mini-smt-FS-020-HDS-010-SDS-010-SMS-010-vlan4-client-dhcp-slaac"
    "mini-smt-FS-020-HDS-010-SDS-010-SMS-010-upstream-selector"
  ];
  noRealizationNodes = inventory: (((inventory.realization or { }).nodes or { }) == { });
  noEndpointClientIntent = intent:
    ((intent.control_plane_model.data.active-lab.test-clients.runtimeTargets or { }) == { })
    && ((intent.control_plane_model.data.active-lab.test-clients.endpointAssignment or { }) == { });
  managementOk = uplinks:
    uplinks.management.vlan == 2
    && uplinks.management.bridge == "vlan2"
    && uplinks.management.ipv4.dhcp == true
    && uplinks.management.ipv6.acceptRA == false;
  rowSourceOk = intent:
    intent ? mini-smt
    && intent.mini-smt ? "FS-020-HDS-010-SDS-010-SMS-010"
    && builtins.any
      (relation: relation.id == "FS-020-HDS-010-SDS-010-SMS-010__mini-verify")
      intent.mini-smt."FS-020-HDS-010-SDS-010-SMS-010".communicationContract.relations;
in
  require (current.selection.layer == "SMT") "FS-020 source-class-assignment SMT selector layer mismatch"
  && require (current.selection.selector == "FS-020-HDS-010-SDS-010-SMS-010") "FS-020 source-class-assignment SMT selector id mismatch"
  && require (current.selection.traceId == "FS-020-HDS-010-SDS-010-SMS-010") "FS-020 source-class-assignment SMT trace mismatch"
  && require (names inventoryNixos.realization.nodes == expectedNodes) "FS-020 source-class-assignment NixOS inventory must realize exactly the five-node mini path"
  && require (names inventoryClab.realization.nodes == expectedNodes) "FS-020 source-class-assignment CLAB inventory must realize exactly the five-node mini path"
  && require (noRealizationNodes inventoryClients) "FS-020 source-class-assignment test-client inventory must not realize router nodes"
  && require (names inventoryNixos.deploymentHosts == [ "s-router-nixos" ]) "FS-020 source-class-assignment NixOS inventory must only expose s-router-nixos"
  && require (names inventoryClab.deploymentHosts == [ "s-router-clab" ]) "FS-020 source-class-assignment CLAB inventory must only expose s-router-clab"
  && require (names inventoryClients.deploymentHosts == [ "s-router-test-clients" ]) "FS-020 source-class-assignment test-client inventory must only expose s-router-test-clients"
  && require (builtins.all (name: inventoryNixos.realization.nodes.${name}.host == "s-router-nixos") expectedNodes) "FS-020 source-class-assignment NixOS mini nodes must stay on s-router-nixos"
  && require (builtins.all (name: inventoryClab.realization.nodes.${name}.host == "s-router-clab") expectedNodes) "FS-020 source-class-assignment CLAB mini nodes must stay on s-router-clab"
  && require (activeIntentNixos == activeIntentClab) "FS-020 source-class-assignment router host-specific intent aliases must share the selected row intent"
  && require (rowSourceOk activeIntentNixos) "FS-020 source-class-assignment router host-specific intent must preserve the row mini-smt source"
  && require (noEndpointClientIntent activeIntentClients) "FS-020 source-class-assignment test-client host-specific intent must be a no-endpoint source"
  && require (activeIntentClients.control_plane_model.deployment.hosts ? s-router-test-clients) "FS-020 source-class-assignment test-client host-specific intent must keep s-router-test-clients"
  && require (activeInventoryNixos == inventoryNixos) "FS-020 source-class-assignment s-router-nixos inventory alias must preserve the selected row inventory"
  && require (activeInventoryClab == inventoryClab) "FS-020 source-class-assignment s-router-clab inventory alias must preserve the selected row inventory"
  && require (activeInventoryClients == inventoryClients) "FS-020 source-class-assignment s-router-test-clients inventory alias must preserve the selected row inventory"
  && require ((import (repoRoot + "/active-lab/clients-s-router-test-clients.nix")) == inventoryClients) "FS-020 source-class-assignment clients alias must preserve the no-router client inventory"
  && require (managementOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "FS-020 source-class-assignment NixOS inventory must preserve VLAN2 management"
  && require (managementOk inventoryClab.deploymentHosts.s-router-clab.uplinks) "FS-020 source-class-assignment CLAB inventory must preserve VLAN2 management"
  && require (managementOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks) "FS-020 source-class-assignment test-client inventory must preserve VLAN2 management"
' >/dev/null || fail "SMT FS-020-HDS-010-SDS-010-SMS-010 selection failed"

"${selector}" SMT FS-166-HDS-010-SDS-010-SMS-902 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.layer == "SMT") "renderer SMT selector layer mismatch"
  && require (current.selection.selector == "FS-166-HDS-010-SDS-010-SMS-902") "renderer SMT selector id mismatch"
  && require (current.selection.traceId == "FS-166-HDS-010-SDS-010-SMS-902") "renderer SMT suffixed trace mismatch"
  && require (current.selection.sourceRoot == "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-902") "renderer SMT source root must use concrete SMS row directory"
  && require (active.intent.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-902") "renderer SMT active-lab import mismatch"
  && require (activeIntentNixos.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-902") "renderer SMT s-router-nixos host intent must import selected NixOS CPM"
  && require (activeIntentClab.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-902") "renderer SMT s-router-clab host intent must carry selected trace"
  && require (activeIntentClab.control_plane_model.data.active-lab.clab.runtimeTargets == { }) "renderer SMT s-router-clab host intent must be no-runtime for NixOS renderer rows"
  && require (activeIntentClab.control_plane_model.deployment.hosts ? s-router-clab) "renderer SMT s-router-clab host intent must keep host substrate"
  && require (activeIntentClients.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-902") "renderer SMT s-router-test-clients host intent must carry selected trace"
  && require (activeIntentClients.control_plane_model.data.active-lab.test-clients.runtimeTargets == { }) "renderer SMT s-router-test-clients host intent must be no-runtime for NixOS renderer rows"
  && require (activeIntentClients.control_plane_model.deployment.hosts ? s-router-test-clients) "renderer SMT s-router-test-clients host intent must keep host substrate"
' >/dev/null || fail "SMT renderer selection failed"

"${selector}" SMT FS-166-HDS-010-SDS-010-SMS-903 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  activeInventoryClients = import (repoRoot + "/active-lab/inventory-s-router-test-clients.nix");
  require = cond: msg: if cond then true else throw msg;
  defaultTrace = "FS-166-HDS-010-SDS-010-SMS-901";
  clientTrace = "FS-166-HDS-010-SDS-010-SMS-903";
  clientSite = activeIntentClients.control_plane_model.data.acme.site-a;
in
  require (current.selection.layer == "SMT") "renderer-nixos-clients selector layer mismatch"
  && require (current.selection.selector == "FS-166-HDS-010-SDS-010-SMS-903") "renderer-nixos-clients selector id mismatch"
  && require (current.selection.traceId == clientTrace) "renderer-nixos-clients trace mismatch"
  && require (current.selection.sourcePath == "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-access-endpoint-cpm.nix") "renderer-nixos-clients source path mismatch"
  && require (active.intent.control_plane_model.meta.traceId == defaultTrace) "renderer-nixos-clients must preserve the global NixOS runtime CPM"
  && require (activeIntentNixos.control_plane_model.meta.traceId == defaultTrace) "renderer-nixos-clients must preserve s-router-nixos host intent"
  && require (activeIntentClab.control_plane_model.meta.traceId == clientTrace) "renderer-nixos-clients must install a client-trace no-runtime CLAB host intent"
  && require (activeIntentClab.control_plane_model.data.active-lab.clab.runtimeTargets == { }) "renderer-nixos-clients must not expose router targets on s-router-clab"
  && require (activeIntentClab.control_plane_model.deployment.hosts ? s-router-clab) "renderer-nixos-clients CLAB no-runtime intent must keep host substrate"
  && require (activeIntentClients.control_plane_model.meta.traceId == clientTrace) "renderer-nixos-clients must install the client CPM on s-router-test-clients"
  && require (clientSite.runtimeTargets == { }) "renderer-nixos-clients client CPM must not carry router runtime targets"
  && require (clientSite.endpointAssignment.poc-client.bridge == "client") "renderer-nixos-clients client CPM must carry poc-client endpointAssignment"
  && require (inventoryClients.deploymentHosts ? s-router-test-clients) "renderer-nixos-clients inventory must keep s-router-test-clients"
  && require (inventoryClients.deploymentHosts.s-router-test-clients.bridgeNetworks ? client) "renderer-nixos-clients inventory must expose client bridge"
  && require (!(inventoryClients.deploymentHosts ? s-router-nixos)) "renderer-nixos-clients inventory must not expose s-router-nixos"
  && require (!(inventoryClients.deploymentHosts ? s-router-clab)) "renderer-nixos-clients inventory must not expose s-router-clab"
  && require (activeInventoryClients == inventoryClients) "renderer-nixos-clients host-specific inventory alias must preserve client inventory"
' >/dev/null || fail "SMT FS-166-HDS-010-SDS-010-SMS-903 selection failed"

"${selector}" SMT FS-166-HDS-010-SDS-010-SMS-904 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  require = cond: msg: if cond then true else throw msg;
  defaultTrace = "FS-166-HDS-010-SDS-010-SMS-901";
  clabTrace = "FS-166-HDS-010-SDS-010-SMS-904";
  clabTargets = builtins.attrNames activeIntentClab.control_plane_model.data.acme.lab.runtimeTargets;
  clabRealizationNodes = inventoryClab.realization.nodes or { };
  clabRealizationNames = builtins.attrNames clabRealizationNodes;
in
  require (current.selection.layer == "SMT") "renderer-clab selector layer mismatch"
  && require (current.selection.selector == "FS-166-HDS-010-SDS-010-SMS-904") "renderer-clab selector id mismatch"
  && require (current.selection.traceId == clabTrace) "renderer-clab trace mismatch"
  && require (current.selection.sourcePath == "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix") "renderer-clab source path mismatch"
  && require (active.intent.control_plane_model.meta.traceId == defaultTrace) "renderer-clab must preserve the global NixOS runtime CPM"
  && require (activeIntentNixos.control_plane_model.meta.traceId == defaultTrace) "renderer-clab must preserve s-router-nixos host intent"
  && require (activeIntentClab.control_plane_model.meta.traceId == clabTrace) "renderer-clab must install the CLAB CPM on s-router-clab"
  && require (clabTargets == [ "edge-a" "edge-b" ]) "renderer-clab s-router-clab host intent must expose only edge-a and edge-b"
  && require (activeIntentClab.control_plane_model.render.hosts.s-router-clab.deploymentHost == "s-router-clab") "renderer-clab s-router-clab host intent must target s-router-clab"
  && require (activeIntentClab.deploymentHosts ? s-router-clab) "renderer-clab s-router-clab host intent must expose s-router-clab deployment host"
  && require (clabRealizationNames == [ "edge-a" "edge-b" ]) "renderer-clab inventory must expose realization nodes for edge-a and edge-b"
  && require (clabRealizationNodes.edge-a.host == "s-router-clab") "renderer-clab edge-a realization host mismatch"
  && require (clabRealizationNodes.edge-b.host == "s-router-clab") "renderer-clab edge-b realization host mismatch"
  && require (clabRealizationNodes.edge-a.logicalNode == activeIntentClab.control_plane_model.data.acme.lab.runtimeTargets.edge-a.logicalNode) "renderer-clab edge-a realization logical node mismatch"
  && require (clabRealizationNodes.edge-b.logicalNode == activeIntentClab.control_plane_model.data.acme.lab.runtimeTargets.edge-b.logicalNode) "renderer-clab edge-b realization logical node mismatch"
  && require (activeIntentClients.control_plane_model.meta.traceId == clabTrace) "renderer-clab must install a CLAB-trace no-runtime test-client host intent"
  && require (activeIntentClients.control_plane_model.data.active-lab.test-clients.runtimeTargets == { }) "renderer-clab must not expose CLAB targets on s-router-test-clients"
  && require (activeIntentClients.control_plane_model.deployment.hosts ? s-router-test-clients) "renderer-clab test-client no-runtime intent must keep host substrate"
  && require (inventoryNixos.activeLabInventoryStub.miniSmtId == defaultTrace) "renderer-clab must preserve NixOS inventory shim"
  && require (inventoryNixos.activeLabInventoryStub.runtimeManagement.vlan2 == "management-only") "renderer-clab must preserve NixOS management metadata"
  && require (inventoryClab.activeLabInventoryStub.miniSmtId == clabTrace) "renderer-clab must preserve CLAB provenance shim"
  && require (inventoryClab.deploymentHosts ? s-router-clab) "renderer-clab CLAB inventory must expose s-router-clab"
' >/dev/null || fail "SMT FS-166-HDS-010-SDS-010-SMS-904 selection failed"

"${selector}" SMT FS-166-HDS-010-SDS-010-SMS-905 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  sopsNixos = import (repoRoot + "/current-lab/sops-routing-s-router-nixos.nix");
  require = cond: msg: if cond then true else throw msg;
  defaultTrace = "FS-166-HDS-010-SDS-010-SMS-901";
  wireguardTrace = "FS-166-HDS-010-SDS-010-SMS-905";
  nixosTargets = builtins.attrNames activeIntentNixos.control_plane_model.data.acme.lab.runtimeTargets;
  sopsSecretNames = builtins.attrNames sopsNixos.sops.secrets;
  wgSecret = sopsNixos.sops.secrets."wireguard-mini-provider-private-key";
in
  require (current.selection.layer == "SMT") "renderer-wireguard selector layer mismatch"
  && require (current.selection.selector == "FS-166-HDS-010-SDS-010-SMS-905") "renderer-wireguard selector id mismatch"
  && require (current.selection.traceId == wireguardTrace) "renderer-wireguard trace mismatch"
  && require (current.selection.sourcePath == "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/wireguard-provider-contract.nix") "renderer-wireguard source path mismatch"
  && require (active.intent.control_plane_model.meta.traceId == defaultTrace) "renderer-wireguard must preserve the global NixOS runtime CPM"
  && require (activeIntentNixos.control_plane_model.meta.traceId == wireguardTrace) "renderer-wireguard must install the WG CPM on s-router-nixos"
  && require (activeIntentClab.control_plane_model.meta.traceId == wireguardTrace) "renderer-wireguard must install an FS-tagged empty CLAB intent"
  && require (activeIntentClab.control_plane_model.data.active-lab.clab.runtimeTargets == { }) "renderer-wireguard must not expose router targets on s-router-clab"
  && require (activeIntentClients.control_plane_model.meta.traceId == wireguardTrace) "renderer-wireguard must install an FS-tagged empty test-client intent"
  && require (activeIntentClients.control_plane_model.data.active-lab.test-clients.runtimeTargets == { }) "renderer-wireguard must not expose router targets on s-router-test-clients"
  && require (nixosTargets == [ "wireguard-egress" ]) "renderer-wireguard s-router-nixos host intent must expose only wireguard-egress"
  && require (activeIntentNixos.control_plane_model.wgInventory.wg-layer-entry.privateKeyFile == "/run/secrets/wireguard-mini-provider-private-key") "renderer-wireguard must expose row-local wgInventory"
  && require (sopsSecretNames == [ "wireguard-mini-provider-private-key" ]) "renderer-wireguard must not inherit HAT PPPoE or unrelated SOPS secrets"
  && require (sopsNixos.sops.secrets ? "wireguard-mini-provider-private-key") "renderer-wireguard must expose the row-local sops secret to s-router-nixos"
  && require (wgSecret.group == "systemd-network") "renderer-wireguard sops secret must be readable by systemd-networkd"
  && require (wgSecret.mode == "0440") "renderer-wireguard sops secret mode must allow systemd-network group read"
  && require (builtins.match ".*GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-905/secrets/sops-s-router-nixos.yaml" (toString sopsNixos.sops.secrets."wireguard-mini-provider-private-key".sopsFile) != null) "renderer-wireguard must use the FS-166 row-owned SOPS file"
' >/dev/null || fail "SMT FS-166-HDS-010-SDS-010-SMS-905 selection failed"

"${selector}" SMT FS-470-HDS-010-SDS-010-SMS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  sopsNixos = import (repoRoot + "/current-lab/sops-routing-s-router-nixos.nix");
  require = cond: msg: if cond then true else throw msg;
  defaultTrace = "FS-166-HDS-010-SDS-010-SMS-901";
  wireguardTrace = "FS-470-HDS-010-SDS-010-SMS-010";
  nixosTargets = builtins.attrNames activeIntentNixos.control_plane_model.data.acme.lab.runtimeTargets;
  providerContract = activeIntentNixos.control_plane_model.providerContracts.wireguard.wg-remote-egress;
  sopsSecretNames = builtins.attrNames sopsNixos.sops.secrets;
  wgSecret = sopsNixos.sops.secrets."wireguard-mini-provider-private-key";
in
  require (current.selection.layer == "SMT") "wireguard-remote-egress selector layer mismatch"
  && require (current.selection.selector == "FS-470-HDS-010-SDS-010-SMS-010") "wireguard-remote-egress selector id mismatch"
  && require (current.selection.traceId == wireguardTrace) "wireguard-remote-egress trace mismatch"
  && require (current.selection.sourcePath == "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix") "wireguard-remote-egress source path mismatch"
  && require (active.intent.control_plane_model.meta.traceId == defaultTrace) "wireguard-remote-egress must preserve the global NixOS runtime CPM"
  && require (activeIntentNixos.control_plane_model.meta.traceId == wireguardTrace) "wireguard-remote-egress must install the FS-470 WG CPM on s-router-nixos"
  && require (activeIntentClab.control_plane_model.meta.traceId == wireguardTrace) "wireguard-remote-egress must install an FS-tagged empty CLAB intent"
  && require (activeIntentClab.control_plane_model.data.active-lab.clab.runtimeTargets == { }) "wireguard-remote-egress must not expose router targets on s-router-clab"
  && require (activeIntentClients.control_plane_model.meta.traceId == wireguardTrace) "wireguard-remote-egress must install an FS-tagged empty test-client intent"
  && require (activeIntentClients.control_plane_model.data.active-lab.test-clients.runtimeTargets == { }) "wireguard-remote-egress must not expose router targets on s-router-test-clients"
  && require (nixosTargets == [ "wireguard-remote-egress" ]) "wireguard-remote-egress s-router-nixos host intent must expose only wireguard-remote-egress"
  && require (activeIntentNixos.control_plane_model.wgInventory.wg-remote-egress.interface == "wg-re-egress0") "wireguard-remote-egress wgInventory interface mismatch"
  && require (providerContract.id == "fs470-remote-egress") "wireguard-remote-egress provider contract id mismatch"
  && require (providerContract.profile.generatedPeer.privateKeyFile == "/run/secrets/wireguard-mini-provider-private-key") "wireguard-remote-egress provider contract must use row-local sops secret"
  && require (providerContract.nat.ipv4.enable == true && providerContract.nat.ipv6.enable == true) "wireguard-remote-egress provider contract must enable NAT44/NAT66"
  && require (sopsSecretNames == [ "wireguard-mini-provider-private-key" ]) "wireguard-remote-egress must not inherit HAT PPPoE or unrelated SOPS secrets"
  && require (sopsNixos.sops.secrets ? "wireguard-mini-provider-private-key") "wireguard-remote-egress must expose the row-local sops secret to s-router-nixos"
  && require (wgSecret.group == "systemd-network") "wireguard-remote-egress sops secret must be readable by systemd-networkd/simple WG renderers"
  && require (wgSecret.mode == "0440") "wireguard-remote-egress sops secret mode must allow systemd-network group read"
  && require (builtins.match ".*GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/secrets/sops-s-router-nixos.yaml" (toString sopsNixos.sops.secrets."wireguard-mini-provider-private-key".sopsFile) != null) "wireguard-remote-egress must use the FS-470 row-owned SOPS file"
' >/dev/null || fail "SMT FS-470-HDS-010-SDS-010-SMS-010 selection failed"

"${selector}" SMT FS-166-HDS-010-SDS-010-SMS-906 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  activeIntentNixos = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
  activeIntentClab = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  sopsNixos = import (repoRoot + "/current-lab/sops-routing-s-router-nixos.nix") {};
  require = cond: msg: if cond then true else throw msg;
  defaultTrace = "FS-166-HDS-010-SDS-010-SMS-901";
  nebulaTrace = "FS-166-HDS-010-SDS-010-SMS-906";
  nixosTargets = builtins.attrNames activeIntentNixos.control_plane_model.data.acme.lab.runtimeTargets;
  overlay = activeIntentNixos.control_plane_model.data.acme.lab.overlays.nebula-layer-entry;
  secrets = sopsNixos.sops.secrets;
in
  require (current.selection.layer == "SMT") "renderer-nebula selector layer mismatch"
  && require (current.selection.selector == "FS-166-HDS-010-SDS-010-SMS-906") "renderer-nebula selector id mismatch"
  && require (current.selection.traceId == nebulaTrace) "renderer-nebula trace mismatch"
  && require (current.selection.sourcePath == "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-nebula-cpm.nix") "renderer-nebula source path mismatch"
  && require (active.intent.control_plane_model.meta.traceId == defaultTrace) "renderer-nebula must preserve the global NixOS runtime CPM"
  && require (activeIntentNixos.control_plane_model.meta.traceId == nebulaTrace) "renderer-nebula must install the Nebula CPM on s-router-nixos"
  && require (activeIntentClab.control_plane_model.meta.traceId == nebulaTrace) "renderer-nebula must install an FS-tagged empty CLAB intent"
  && require (activeIntentClab.control_plane_model.data.active-lab.clab.runtimeTargets == { }) "renderer-nebula must not expose router targets on s-router-clab"
  && require (activeIntentClients.control_plane_model.meta.traceId == nebulaTrace) "renderer-nebula must install an FS-tagged empty test-client intent"
  && require (activeIntentClients.control_plane_model.data.active-lab.test-clients.runtimeTargets == { }) "renderer-nebula must not expose router targets on s-router-test-clients"
  && require (nixosTargets == [ "lab-client-nebula" "lab-lighthouse" ]) "renderer-nebula s-router-nixos host intent must expose only the Nebula client and lighthouse"
  && require (activeIntentNixos.deploymentHosts ? s-router-nixos) "renderer-nebula s-router-nixos host intent must expose s-router-nixos deployment host"
  && require (!(activeIntentNixos.deploymentHosts ? s-router-clab)) "renderer-nebula host intent must not expose s-router-clab deployment host data"
  && require (!(activeIntentNixos.deploymentHosts ? s-router-test-clients)) "renderer-nebula host intent must not expose s-router-test-clients deployment host data"
  && require (overlay.nebula.lighthouse.node == "lab-lighthouse") "renderer-nebula overlay must identify the row lighthouse"
  && require (overlay.runtimeNodes.lab-lighthouse.service.interface == "nebula1") "renderer-nebula lighthouse service interface mismatch"
  && require (overlay.runtimeNodes.lab-lighthouse.service.listenHost == "0.0.0.0") "renderer-nebula lighthouse listen host mismatch"
  && require (overlay.runtimeNodes.lab-lighthouse.service.port == 4242) "renderer-nebula lighthouse listen port mismatch"
  && require (overlay.runtimeNodes.lab-client-nebula.service.interface == "nebula1") "renderer-nebula client service interface mismatch"
  && require (overlay.runtimeNodes.lab-client-nebula.service.listenHost == "0.0.0.0") "renderer-nebula client listen host mismatch"
  && require (overlay.runtimeNodes.lab-client-nebula.service.port == 4242) "renderer-nebula client listen port mismatch"
  && require ((overlay.nebula.runtimeNodes.lab-client-nebula.unsafeRoutes or [ ]) == [ ]) "renderer-nebula row must not inject unsafe payload routes"
  && require (secrets."nebula-profile-lab-lighthouse-ca-crt".path == "/persist/nebula-runtime/profiles/lab-lighthouse/ca.crt") "renderer-nebula lighthouse CA secret path mismatch"
  && require (builtins.match ".*GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-906/secrets/sops-s-router-nixos.yaml" (toString secrets."nebula-profile-lab-lighthouse-ca-crt".sopsFile) != null) "renderer-nebula must use the FS-166 row-owned SOPS file"
  && require (secrets."nebula-profile-lab-lighthouse-crt".path == "/persist/nebula-runtime/profiles/lab-lighthouse/lab-lighthouse.crt") "renderer-nebula lighthouse cert secret path mismatch"
  && require (secrets."nebula-profile-lab-lighthouse-key".path == "/persist/nebula-runtime/profiles/lab-lighthouse/lab-lighthouse.key") "renderer-nebula lighthouse key secret path mismatch"
  && require (secrets."nebula-profile-lab-client-nebula-ca-crt".path == "/persist/nebula-runtime/profiles/lab-client-nebula/ca.crt") "renderer-nebula client CA secret path mismatch"
  && require (secrets."nebula-profile-lab-client-nebula-crt".path == "/persist/nebula-runtime/profiles/lab-client-nebula/lab-client-nebula.crt") "renderer-nebula client cert secret path mismatch"
  && require (secrets."nebula-profile-lab-client-nebula-key".path == "/persist/nebula-runtime/profiles/lab-client-nebula/lab-client-nebula.key") "renderer-nebula client key secret path mismatch"
' >/dev/null || fail "SMT FS-166-HDS-010-SDS-010-SMS-906 selection failed"

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
  && require (active.intent."mini-smt" ? "FS-500-HDS-010-SDS-010-SMS-010") "SIT FS-500 must select its first registered mini-SMT source"
  && require (inventoryNixos.deploymentHosts ? s-router-nixos) "SIT selection must install runnable NixOS inventory"
' >/dev/null || fail "SIT selection failed"

"${selector}" SIT FS-060-HDS-010-SDS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  activeInventoryClients = import (repoRoot + "/active-lab/inventory-s-router-test-clients.nix");
  require = cond: msg: if cond then true else throw msg;
  expectedNodes = [
    "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-client-edge"
    "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-downstream-selector"
    "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-policy"
    "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-vlan4-client-dhcp-slaac"
    "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-upstream-selector"
  ];
  nixosNodes = builtins.attrNames inventoryNixos.realization.nodes;
  clabNodes = builtins.attrNames inventoryClab.realization.nodes;
  clientNodes = builtins.attrNames inventoryClients.realization.nodes;
in
  require (current.selection.layer == "SIT") "FS-060 SIT selector layer mismatch"
  && require (current.selection.selector == "FS-060-HDS-010-SDS-010") "FS-060 SIT selector id mismatch"
  && require (current.selection.sourceRoot == "GAMP/SIT/FS-060-HDS-010-SDS-010") "FS-060 SIT source root mismatch"
  && require (current.selection.sourcePath == "GAMP/SIT/FS-060-HDS-010-SDS-010/default.nix") "FS-060 SIT source path mismatch"
  && require (active.intent ? "mini-smt") "FS-060 SIT selection must install the row-local mini-SMT source"
  && require (active.intent."mini-smt" ? "FS-060-HDS-010-SDS-010-SMS-010") "FS-060 SIT must select the runtime-fact mini source"
  && require (manifest.tests."FS-060-HDS-010-SDS-010-SMS-010".maxRuntimeTargets == 5) "FS-060 runtime-fact mini cap must be five targets"
  && require (nixosNodes == expectedNodes) "FS-060 NixOS SIT must realize exactly the five-node runtime-fact path"
  && require (clabNodes == expectedNodes) "FS-060 CLAB SIT must realize exactly the five-node runtime-fact path"
  && require (clientNodes == [ ]) "FS-060 test-client SIT must not realize router runtime targets"
  && require (inventoryClients.deploymentHosts ? s-router-test-clients) "FS-060 test-client SIT inventory must keep s-router-test-clients host substrate"
  && require (!(inventoryClients.deploymentHosts ? s-router-nixos)) "FS-060 test-client SIT inventory must not carry router host substrate"
  && require (activeInventoryClients == inventoryClients) "FS-060 test-client SIT host inventory must preserve row-local client inventory"
  && require (inventoryClients.deploymentHosts.s-router-test-clients.uplinks.management.vlan == 2) "FS-060 test-client SIT inventory must preserve VLAN2 management"
  && require (builtins.all (name: inventoryNixos.realization.nodes.${name}.host == "s-router-nixos") nixosNodes) "FS-060 NixOS mini nodes must stay on s-router-nixos"
  && require (builtins.all (name: inventoryClab.realization.nodes.${name}.host == "s-router-clab") clabNodes) "FS-060 CLAB mini nodes must stay on s-router-clab"
' >/dev/null || fail "SIT FS-060 selection failed"

"${selector}" SIT FS-370-HDS-010-SDS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  activeInventoryClients = import (repoRoot + "/active-lab/inventory-s-router-test-clients.nix");
  require = cond: msg: if cond then true else throw msg;
  expectedNodes = [
    "mini-smt-FS-370-HDS-010-SDS-010-SMS-050-client-edge"
    "mini-smt-FS-370-HDS-010-SDS-010-SMS-050-downstream-selector"
    "mini-smt-FS-370-HDS-010-SDS-010-SMS-050-policy"
    "mini-smt-FS-370-HDS-010-SDS-010-SMS-050-vlan4-client-dhcp-slaac"
    "mini-smt-FS-370-HDS-010-SDS-010-SMS-050-upstream-selector"
  ];
  nixosNodes = builtins.attrNames inventoryNixos.realization.nodes;
  clabNodes = builtins.attrNames inventoryClab.realization.nodes;
  clientNodes = builtins.attrNames inventoryClients.realization.nodes;
in
  require (current.selection.layer == "SIT") "FS-370 SIT selector layer mismatch"
  && require (current.selection.selector == "FS-370-HDS-010-SDS-010") "FS-370 SIT selector id mismatch"
  && require (current.selection.sourceRoot == "GAMP/SIT/FS-370-HDS-010-SDS-010") "FS-370 SIT source root mismatch"
  && require (active.intent ? "mini-smt") "FS-370 SIT selection must install the row-local mini-SMT source"
  && require (active.intent."mini-smt" ? "FS-370-HDS-010-SDS-010-SMS-050") "FS-370 SIT must select the lane-egress mini source"
  && require (manifest.tests."FS-370-HDS-010-SDS-010-SMS-050".maxRuntimeTargets == 5) "FS-370 lane-egress mini cap must be five targets"
  && require (nixosNodes == expectedNodes) "FS-370 NixOS SIT must realize exactly the five-node lane path"
  && require (clabNodes == expectedNodes) "FS-370 CLAB SIT must realize exactly the five-node lane path"
  && require (clientNodes == expectedNodes) "FS-370 test-client SIT must realize exactly the five-node lane path"
  && require (inventoryClients.deploymentHosts ? s-router-test-clients) "FS-370 test-client SIT inventory must keep s-router-test-clients host substrate"
  && require (activeInventoryClients == inventoryClients) "FS-370 test-client SIT host inventory must preserve row-local client inventory"
  && require (inventoryClients.deploymentHosts.s-router-test-clients.uplinks.management.vlan == 2) "FS-370 test-client SIT inventory must preserve VLAN2 management"
  && require (builtins.all (name: inventoryNixos.realization.nodes.${name}.host == "s-router-nixos") nixosNodes) "FS-370 NixOS mini nodes must stay on s-router-nixos"
  && require (builtins.all (name: inventoryClab.realization.nodes.${name}.host == "s-router-clab") clabNodes) "FS-370 CLAB mini nodes must stay on s-router-clab"
  && require (builtins.all (name: inventoryClients.realization.nodes.${name}.host == "s-router-test-clients") clientNodes) "FS-370 test-client mini nodes must stay on s-router-test-clients"
' >/dev/null || fail "SIT FS-370 selection failed"

"${selector}" SIT FS-540-HDS-010-SDS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  inventoryHetz = import (repoRoot + "/current-lab/inventory-hetz.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  activeIntentClients = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
  activeInventoryClients = import (repoRoot + "/active-lab/inventory-s-router-test-clients.nix");
  sopsHetz = import (repoRoot + "/active-lab/sops-routing-s-router-hetz.nix") {};
  require = cond: msg: if cond then true else throw msg;
  expectedNodes = [
    "mini-smt-FS-540-HDS-010-SDS-010-SMS-020-access-dns"
    "mini-smt-FS-540-HDS-010-SDS-010-SMS-020-downstream-selector"
    "mini-smt-FS-540-HDS-010-SDS-010-SMS-020-policy"
    "mini-smt-FS-540-HDS-010-SDS-010-SMS-020-resolver-node"
    "mini-smt-FS-540-HDS-010-SDS-010-SMS-020-upstream-selector"
  ];
  nixosNodes = builtins.attrNames inventoryNixos.realization.nodes;
  clabNodes = builtins.attrNames inventoryClab.realization.nodes;
  hetzNodes = builtins.attrNames inventoryHetz.realization.nodes;
  nixosUplinks = inventoryNixos.deploymentHosts.s-router-nixos.uplinks;
  clabUplinks = inventoryClab.deploymentHosts.s-router-clab.uplinks;
  hetzUplinks = inventoryHetz.deploymentHosts.s-router-hetz.uplinks;
  clabProvider = builtins.head inventoryClab.containerlab.labEmulation.requests;
  clientSite = activeIntentClients.control_plane_model.data."mini-smt"."FS-540-HDS-010-SDS-010-SMS-020";
  clientEndpoint = clientSite.endpointAssignment."dns-resolver-config-access-dns" or {};
in
  require (current.selection.layer == "SIT") "FS-540 SIT selector layer mismatch"
  && require (current.selection.selector == "FS-540-HDS-010-SDS-010") "FS-540 SIT selector id mismatch"
  && require (current.selection.sourceRoot == "GAMP/SIT/FS-540-HDS-010-SDS-010") "FS-540 SIT source root mismatch"
  && require (active.intent ? "mini-smt") "FS-540 SIT selection must install the row-local mini-SMT source"
  && require (active.intent."mini-smt" ? "FS-540-HDS-010-SDS-010-SMS-020") "FS-540 SIT must select the DNS resolver mini source"
  && require (manifest.tests."FS-540-HDS-010-SDS-010-SMS-020".maxRuntimeTargets == 5) "FS-540 DNS resolver mini cap must be five targets"
  && require (nixosNodes == expectedNodes) "FS-540 NixOS SIT must realize exactly the five-node DNS mini path"
  && require (clabNodes == expectedNodes) "FS-540 CLAB SIT must realize exactly the five-node DNS mini path"
  && require (hetzNodes == expectedNodes) "FS-540 Hetz SIT must realize exactly the five-node DNS mini path"
  && require (builtins.all (name: inventoryNixos.realization.nodes.${name}.host == "s-router-nixos") nixosNodes) "FS-540 NixOS mini nodes must stay on s-router-nixos"
  && require (builtins.all (name: inventoryClab.realization.nodes.${name}.host == "s-router-clab") clabNodes) "FS-540 CLAB mini nodes must stay on s-router-clab"
  && require (builtins.all (name: inventoryHetz.realization.nodes.${name}.host == "s-router-hetz") hetzNodes) "FS-540 Hetz mini nodes must stay on s-router-hetz"
  && require (!(inventoryHetz.realization.nodes ? esp-clab-clab-router-access-admin)) "FS-540 Hetz SIT must not import HAT esp.clab realization nodes"
  && require (inventoryClients.deploymentHosts ? s-router-test-clients) "FS-540 test-client SIT inventory must keep s-router-test-clients host substrate"
  && require (activeInventoryClients == inventoryClients) "FS-540 test-client SIT host inventory must preserve row-local client inventory"
  && require (inventoryClients.deploymentHosts.s-router-test-clients.uplinks.management.vlan == 2) "FS-540 test-client SIT inventory must preserve VLAN2 management"
  && require (activeIntentClients.control_plane_model.realization.nodes == { }) "FS-540 test-client SIT intent must not synthesize router realization nodes"
  && require (clientSite.runtimeTargets == { }) "FS-540 test-client SIT intent must not synthesize router runtime targets"
  && require (builtins.hasAttr "dns-resolver-config-access-dns" clientSite.endpointAssignment) "FS-540 test-client SIT intent must expose the DNS access endpoint assignment"
  && require (clientEndpoint.owningSubstrate == "s-router-test-clients" && clientEndpoint.mode == "static") "FS-540 test-client SIT endpoint assignment must target s-router-test-clients as a static endpoint"
  && require (clientEndpoint.bridge == "br-mini-smt-dns-resolver-config-tenant-client") "FS-540 test-client SIT endpoint assignment must use the modeled tenant bridge"
  && require (clientEndpoint.static.address == "10.54.10.1" && clientEndpoint.static.address6 == "fd42:540::1") "FS-540 test-client SIT endpoint assignment must carry the DNS listener addresses"
  && require (activeIntentClients.deploymentHosts.s-router-test-clients.uplinks.management.vlan == 2) "FS-540 test-client SIT intent must preserve VLAN2 management"
  && require (nixosUplinks ? testnet-vlan4 && nixosUplinks.testnet-vlan4.vlan == 4 && nixosUplinks.testnet-vlan4.mode == "vlan" && nixosUplinks.testnet-vlan4.ipv4.method == "dhcp") "FS-540 NixOS mini uplink must be explicit VLAN4 link with DHCP addressing, not untagged testnet"
  && require (clabUplinks ? testnet-vlan4 && clabUplinks.testnet-vlan4.vlan == 4 && clabUplinks.testnet-vlan4.mode == "vlan" && clabUplinks.testnet-vlan4.ipv4.method == "dhcp") "FS-540 CLAB mini uplink must be explicit VLAN4 link with DHCP addressing, not untagged testnet"
  && require (hetzUplinks ? testnet-vlan4 && hetzUplinks.testnet-vlan4.vlan == 4 && hetzUplinks.testnet-vlan4.mode == "vlan" && hetzUplinks.testnet-vlan4.ipv4.method == "dhcp") "FS-540 Hetz mini uplink must be explicit VLAN4 link with DHCP addressing, not HAT inventory"
  && require (sopsHetz._module.args.activeLabSopsStub.hostName == "s-router-hetz") "FS-540 Hetz SIT SOPS route must be an empty active-lab stub"
  && require (!(sopsHetz ? sops)) "FS-540 Hetz SIT SOPS route must not inherit HAT PPPoE secrets"
  && require (inventoryClab.containerlab.capabilities.labEmulation == true) "FS-540 CLAB SIT source must preserve explicit lab-emulation capability"
  && require (inventoryClab.containerlab.labEmulation.scope == "harness") "FS-540 CLAB SIT provider emulation must remain harness-scoped"
  && require (clabProvider.providerEmulationMode == "fake-provider" && clabProvider.handoffVlan == 11 && clabProvider.liveUpstreamVlan == 4) "FS-540 CLAB SIT must preserve fake-provider VLAN11 handoff with VLAN4 live upstream"
  && require (clabProvider.dhcp4.address == "10.20.0.1/24" && clabProvider.dhcp4.router == "10.20.0.1" && clabProvider.dhcp4.rangeStart == "10.20.0.20" && clabProvider.dhcp4.rangeEnd == "10.20.0.99" && clabProvider.dhcp4.leaseTime == "5m" && clabProvider.dhcp4.sourcePrefix == "10.20.0.0/24") "FS-540 CLAB SIT fake-provider must declare explicit DHCPv4 service parameters"
  && require (clabProvider.nat44.enabled == true && clabProvider.nat44.sourcePrefix == "10.20.0.0/24") "FS-540 CLAB SIT fake-provider must declare explicit NAT44 source prefix"
  && require (clabProvider.handoffVlan != 2 && clabProvider.liveUpstreamVlan != 2) "FS-540 CLAB SIT provider emulation must not use VLAN2"
' >/dev/null || fail "SIT FS-540 selection failed"

"${selector}" SIT FS-800-HDS-010-SDS-020 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  inventoryNixos = import (repoRoot + "/current-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/current-lab/inventory-clab.nix");
  inventoryHetz = import (repoRoot + "/current-lab/inventory-hetz.nix");
  inventoryClients = import (repoRoot + "/current-lab/inventory-test-clients.nix");
  require = cond: msg: if cond then true else throw msg;
  expectedNodes = [
    "mini-smt-FS-800-HDS-010-SDS-020-SMS-040-downstream-selector"
    "mini-smt-FS-800-HDS-010-SDS-020-SMS-040-fabric-core"
    "mini-smt-FS-800-HDS-010-SDS-020-SMS-040-policy"
    "mini-smt-FS-800-HDS-010-SDS-020-SMS-040-pppoe-core"
    "mini-smt-FS-800-HDS-010-SDS-020-SMS-040-provider-handoff-access-a"
    "mini-smt-FS-800-HDS-010-SDS-020-SMS-040-upstream-selector"
  ];
  nixosNodes = builtins.attrNames inventoryNixos.realization.nodes;
  clabNodes = builtins.attrNames inventoryClab.realization.nodes;
  hetzNodes = builtins.attrNames inventoryHetz.realization.nodes;
  hetzUplinks = inventoryHetz.deploymentHosts.s-router-hetz.uplinks;
in
  require (current.selection.layer == "SIT") "FS-800 provider route SIT selector layer mismatch"
  && require (current.selection.selector == "FS-800-HDS-010-SDS-020") "FS-800 provider route SIT selector id mismatch"
  && require (nixosNodes == expectedNodes) "FS-800 provider route NixOS SIT must realize exactly the six-node provider path"
  && require (clabNodes == expectedNodes) "FS-800 provider route CLAB SIT must realize exactly the six-node provider path"
  && require (hetzNodes == expectedNodes) "FS-800 provider route Hetz SIT must realize exactly the six-node provider path"
  && require (builtins.all (name: inventoryNixos.realization.nodes.${name}.host == "s-router-nixos") nixosNodes) "FS-800 provider route NixOS mini nodes must stay on s-router-nixos"
  && require (builtins.all (name: inventoryClab.realization.nodes.${name}.host == "s-router-clab") clabNodes) "FS-800 provider route CLAB mini nodes must stay on s-router-clab"
  && require (builtins.all (name: inventoryHetz.realization.nodes.${name}.host == "s-router-hetz") hetzNodes) "FS-800 provider route Hetz mini nodes must stay on s-router-hetz"
  && require (inventoryClients.deploymentHosts ? s-router-test-clients) "FS-800 provider route test-client inventory must keep s-router-test-clients host substrate"
  && require (((inventoryClients.realization or {}).nodes or {}) == {}) "FS-800 provider route must not render router nodes on s-router-test-clients"
  && require (hetzUplinks ? isp && hetzUplinks.isp.mode == "vlan" && hetzUplinks.isp.vlan == 4 && hetzUplinks.isp.parent == "eth0") "FS-800 provider route Hetz isp uplink must be VLAN4, not raw eth0"
  && require (hetzUplinks ? pppoe-provider && hetzUplinks.pppoe-provider.mode == "vlan" && hetzUplinks.pppoe-provider.vlan == 5 && hetzUplinks.pppoe-provider.parent == "eth0") "FS-800 provider route Hetz pppoe-provider uplink must be VLAN5, not raw eth0"
' >/dev/null || fail "SIT FS-800 provider default-route selection failed"

"${selector}" SIT FS-010-HDS-010-SDS-010 >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.layer == "SIT") "manifest-backed SIT selector layer mismatch"
  && require (current.selection.selector == "FS-010-HDS-010-SDS-010") "manifest-backed SIT selector id mismatch"
  && require (current.selection.sourceKind == "sds-integration-source") "manifest-backed SIT source kind mismatch"
' >/dev/null || fail "manifest-backed SIT FS-010-HDS-010-SDS-010 selection failed"

"${selector}" HAT >/dev/null
REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  current = import (repoRoot + "/current-lab");
  active = import (repoRoot + "/active-lab");
  clients = import (repoRoot + "/active-lab/clients.nix");
  inventory = import (repoRoot + "/active-lab/inventory-nixos.nix");
  inventoryClab = import (repoRoot + "/active-lab/inventory-clab.nix");
  inventoryHostNixos = import (repoRoot + "/active-lab/inventory-s-router-nixos.nix");
  inventoryHostClab = import (repoRoot + "/active-lab/inventory-s-router-clab.nix");
  inventoryHostClients = import (repoRoot + "/active-lab/inventory-s-router-test-clients.nix");
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
  && require (inventoryHostNixos == inventory) "HAT s-router-nixos host inventory should share the selected NixOS HAT inventory"
  && require (inventoryHostClients == inventory) "HAT s-router-test-clients host inventory should share the selected NixOS HAT inventory"
  && require (inventoryHostClab == inventoryClab) "HAT s-router-clab host inventory should share the selected CLAB HAT inventory"
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
  inventoryHostNixos = import (repoRoot + "/active-lab/inventory-s-router-nixos.nix");
  inventoryHostClients = import (repoRoot + "/active-lab/inventory-s-router-test-clients.nix");
  require = cond: msg: if cond then true else throw msg;
in
  require (current.selection.layer == "SAT") "SAT selector layer mismatch"
  && require (inventoryHostNixos == inventory) "SAT s-router-nixos host inventory should share the selected NixOS SAT inventory"
  && require (inventoryHostClients == inventory) "SAT s-router-test-clients host inventory should share the selected NixOS SAT inventory"
  && require (inventory.deployment.hosts ? s-router-nixos) "SAT inventory must expose s-router-nixos"
' >/dev/null || fail "SAT selection failed"

cleanup
trap - EXIT

echo "PASS current-lab-selector"
