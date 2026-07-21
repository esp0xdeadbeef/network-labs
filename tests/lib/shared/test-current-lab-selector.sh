#!/usr/bin/env bash
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
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
  && require (activeIntentClab.control_plane_model.meta.constructionOnly == true) "default s-router-clab host intent must retain the controlled construction-only boundary"
  && require (activeIntentClab.control_plane_model.data.active-lab.construction-only.runtimeTargets == { }) "default s-router-clab host intent must remain no-runtime before replacement injection"
  && require (activeIntentClab.control_plane_model.deployment.hosts ? s-router-clab) "default s-router-clab host intent must keep host substrate"
  && require (activeIntentClients.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-901") "default s-router-test-clients host intent must carry the default trace"
  && require (activeIntentClients.control_plane_model.meta.constructionOnly == true) "default s-router-test-clients host intent must retain the controlled construction-only boundary"
  && require (activeIntentClients.control_plane_model.data.active-lab.construction-only.runtimeTargets == { }) "default s-router-test-clients host intent must remain no-runtime before replacement injection"
  && require (activeIntentClients.control_plane_model.deployment.hosts ? s-router-test-clients) "default s-router-test-clients host intent must keep host substrate"
  && require (builtins.attrNames inventory.deploymentHosts.s-router-nixos.uplinks == [ "management" ]) "default selection must expose only the host management uplink before replacement injection"
  && require (inventory.deploymentHosts.s-router-nixos.uplinks.management.vlan == 2) "default selection must preserve VLAN2 management"
  && require (inventoryHost.deploymentHosts.s-router-nixos.uplinks.management.vlan == 2) "default host-specific NixOS inventory alias must preserve VLAN2 management"
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
  sorted = builtins.sort (left: right: left < right);
  names = attrs: sorted (builtins.attrNames attrs);
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
  internetModeNode = "mini-smt-fs-380-hds-020-sds-010-sms-050-client-edge";
  internetModeProviderNode = "mini-smt-fs-380-hds-020-sds-010-sms-050-emulated-isp";
  expectedInternetModeNodes = sorted [
    internetModeNode
    "mini-smt-fs-380-hds-020-sds-010-sms-050-downstream-selector"
    internetModeProviderNode
    "mini-smt-fs-380-hds-020-sds-010-sms-050-policy"
    "mini-smt-fs-380-hds-020-sds-010-sms-050-upstream-selector"
  ];
  internetModeNodesOk = inventory:
    names inventory.realization.nodes == expectedInternetModeNodes;
  tenantBridge = "br-mini-smt-fs-380-hds-020-sds-010-sms-050-tenant-client";
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
  traceSiteOk = inventory:
    inventory.realization.nodes.${internetModeNode}.logicalNode.site == "FS-380-HDS-020-SDS-010-SMS-050";
  pppoeFactsOk = inventory:
    let
      client = inventory.realization.nodes.${internetModeNode};
      provider = inventory.realization.nodes.${internetModeProviderNode};
    in
    client.services.pppoe.client.interface == "pppoe-handoff-client-edge-emulated-isp"
    && client.services.pppoe.client.runtimeInterface == "ppp0"
    && provider.services.pppoe.server.interface == "pppoe-handoff-client-edge-emulated-isp"
    && provider.services.pppoe.server.providerAddress == "203.0.113.9"
    && provider.services.pppoe.server.customerAddress == "203.0.113.10";
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
  && require (internetModeNodesOk inventoryNixos) "nixos internet-mode realization must expose exactly the canonical five-node staged path"
  && require (inventoryNixos.realization.nodes.${internetModeNode}.host == "s-router-nixos") "nixos internet-mode realization host mismatch"
  && require (traceSiteOk inventoryNixos) "nixos internet-mode realization must retain full trace site binding"
  && require (pppoeFactsOk inventoryNixos) "nixos internet-mode PPPoE facts must migrate onto canonical realization nodes"
  && require (uplinksOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode uplinks must be VLAN4/VLAN5 links with DHCP addressing"
  && require (noTestVlan2 inventoryNixos.deploymentHosts.s-router-nixos.uplinks) "nixos internet-mode test uplinks must not use VLAN2"
  && require (managementOk inventoryClab.deploymentHosts.s-router-clab.uplinks) "clab internet-mode must preserve VLAN2 management"
  && require (managementOk activeInventoryClab.deploymentHosts.s-router-clab.uplinks) "clab host-specific inventory alias must preserve VLAN2 management"
  && require (managementOk inventoryClab.deployment.hosts.s-router-clab.uplinks) "clab internet-mode must expose deployment.hosts management"
  && require (internetModeNodesOk inventoryClab) "clab internet-mode realization must expose exactly the canonical five-node staged path"
  && require (inventoryClab.realization.nodes.${internetModeNode}.host == "s-router-clab") "clab internet-mode realization host mismatch"
  && require (traceSiteOk inventoryClab) "clab internet-mode realization must retain full trace site binding"
  && require (pppoeFactsOk inventoryClab) "clab internet-mode PPPoE facts must migrate onto canonical realization nodes"
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
	  cpmLib = (builtins.getFlake ("path:" + repoRoot + "/../network-control-plane-model")).libBySystem.${builtins.currentSystem};
	  builtNixos = cpmLib.compileAndBuildFromPaths {
	    inputPath = repoRoot + "/current-lab/intent-s-router-nixos.nix";
	    inventoryPath = repoRoot + "/current-lab/inventory-s-router-nixos.nix";
	  };
	  builtClab = cpmLib.compileAndBuildFromPaths {
	    inputPath = repoRoot + "/current-lab/intent-s-router-clab.nix";
	    inventoryPath = repoRoot + "/current-lab/inventory-s-router-clab.nix";
	  };
	  require = cond: msg: if cond then true else throw msg;
	  sorted = builtins.sort (left: right: left < right);
	  names = attrs: sorted (builtins.attrNames attrs);
	  clientEdgeNode = "mini-smt-fs-010-hds-010-sds-010-sms-010-client-edge";
	  expectedNodes = [
	    clientEdgeNode
	    "mini-smt-fs-010-hds-010-sds-010-sms-010-core-vlan4-client-dhcp-slaac"
	    "mini-smt-fs-010-hds-010-sds-010-sms-010-downstream-selector"
	    "mini-smt-fs-010-hds-010-sds-010-sms-010-policy"
	    "mini-smt-fs-010-hds-010-sds-010-sms-010-upstream-selector"
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
	  selectorCount = selectorName: selectorValue: ports:
	    builtins.length (
	      builtins.filter
	        (portName: (ports.${portName}.${selectorName} or null) == selectorValue)
	        (builtins.attrNames ports)
	    );
	  singleClientEdgeDownstreamLink = inventory:
	    let
	      ports = inventory.realization.nodes.${clientEdgeNode}.ports;
	    in
	    selectorCount "link" "p2p-client-edge-downstream-selector" ports == 1;
	  explicitNixosClientEdgePortOk = inventory:
	    let
	      ports = inventory.realization.nodes.${clientEdgeNode}.ports;
	    in
	    singleClientEdgeDownstreamLink inventory
	    && builtins.hasAttr "transit-downstream-selector" ports
	    && ports."transit-downstream-selector".link == "p2p-client-edge-downstream-selector"
	    && ports."transit-downstream-selector".interface.name == "ens3"
	    && !(builtins.hasAttr "p2p-client-edge-downstream-selector" ports);
	  generatedClabClientEdgePortOk = inventory:
	    let
	      ports = inventory.realization.nodes.${clientEdgeNode}.ports;
	    in
	    singleClientEdgeDownstreamLink inventory
	    && builtins.hasAttr "p2p-client-edge-downstream-selector" ports;
	in
	  require (current.selection.layer == "SMT") "FS-010 accepted-source-set SMT selector layer mismatch"
	  && require (current.selection.selector == "FS-010-HDS-010-SDS-010-SMS-010") "FS-010 accepted-source-set SMT selector id mismatch"
	  && require (current.selection.traceId == "FS-010-HDS-010-SDS-010-SMS-010") "FS-010 accepted-source-set SMT trace mismatch"
	  && require (names inventoryNixos.realization.nodes == expectedNodes) "FS-010 accepted-source-set NixOS inventory must realize exactly the five-node mini path"
	  && require (names inventoryClab.realization.nodes == expectedNodes) "FS-010 accepted-source-set CLAB inventory must realize exactly the five-node mini path"
	  && require (explicitNixosClientEdgePortOk inventoryNixos) "FS-010 accepted-source-set NixOS inventory must preserve explicit downstream selector port without generated duplicate"
	  && require (generatedClabClientEdgePortOk inventoryClab) "FS-010 accepted-source-set CLAB inventory must keep exactly one generated downstream selector port"
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
	  && require (builtNixos.control_plane_model.data.mini-smt ? "FS-010-HDS-010-SDS-010-SMS-010") "FS-010 accepted-source-set NixOS CPM evaluation must keep full trace data"
	  && require (builtClab.control_plane_model.data.mini-smt ? "FS-010-HDS-010-SDS-010-SMS-010") "FS-010 accepted-source-set CLAB CPM evaluation must keep full trace data"
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
    "mini-smt-fs-020-hds-010-sds-010-sms-010-client-edge"
    "mini-smt-fs-020-hds-010-sds-010-sms-010-core-vlan4-client-dhcp-slaac"
    "mini-smt-fs-020-hds-010-sds-010-sms-010-downstream-selector"
    "mini-smt-fs-020-hds-010-sds-010-sms-010-policy"
    "mini-smt-fs-020-hds-010-sds-010-sms-010-upstream-selector"
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

assert_controlled_replacement_selection() {
  local trace_id="$1"

  "${selector}" SMT "${trace_id}" >/dev/null
  REPO_ROOT="${repo_root}" TRACE_ID="${trace_id}" nix eval --impure --expr '
  let
    repoRoot = builtins.getEnv "REPO_ROOT";
    traceId = builtins.getEnv "TRACE_ID";
    current = import (repoRoot + "/current-lab");
    active = import (repoRoot + "/active-lab");
    hostIntents = [
      {
        hostName = "s-router-nixos";
        intent = import (repoRoot + "/active-lab/intent-s-router-nixos.nix");
      }
      {
        hostName = "s-router-clab";
        intent = import (repoRoot + "/active-lab/intent-s-router-clab.nix");
      }
      {
        hostName = "s-router-test-clients";
        intent = import (repoRoot + "/active-lab/intent-s-router-test-clients.nix");
      }
    ];
    require = condition: message: if condition then true else throw message;
    validHostIntent = entry:
      entry.intent.control_plane_model.meta.traceId == traceId
      && entry.intent.control_plane_model.meta.constructionOnly == true
      && entry.intent.control_plane_model.data.active-lab.construction-only.runtimeTargets == { }
      && builtins.hasAttr entry.hostName entry.intent.control_plane_model.deployment.hosts
      && entry.intent.control_plane_model.realization.nodes == { };
  in
    require (current.selection.layer == "SMT") "controlled replacement selector layer mismatch"
    && require (current.selection.selector == traceId) "controlled replacement selector mismatch"
    && require (current.selection.traceId == traceId) "controlled replacement trace mismatch"
    && require (current.selection.sourceKind == "replacement-cpm-artifact") "controlled replacement source kind mismatch"
    && require (current.selection.sourceRoot == "GAMP/SMT/" + traceId) "controlled replacement source root mismatch"
    && require (builtins.match ".*/renderer-input/.*" current.selection.sourcePath == null) "superseded direct renderer input selected"
    && require (active.intent.control_plane_model.meta.traceId == traceId) "active-lab replacement trace mismatch"
    && require (builtins.all validHostIntent hostIntents) "replacement selection exposed runtime or lost host substrate"
  ' >/dev/null || fail "controlled replacement selection failed for ${trace_id}"
}

for trace_id in \
  FS-166-HDS-010-SDS-010-SMS-901 \
  FS-166-HDS-010-SDS-010-SMS-902 \
  FS-166-HDS-010-SDS-010-SMS-903 \
  FS-166-HDS-010-SDS-010-SMS-904 \
  FS-166-HDS-010-SDS-010-SMS-905 \
  FS-166-HDS-010-SDS-010-SMS-906; do
  assert_controlled_replacement_selection "${trace_id}"
done

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
    "mini-smt-fs-060-hds-010-sds-010-sms-010-client-edge"
    "mini-smt-fs-060-hds-010-sds-010-sms-010-core-vlan4-client-dhcp-slaac"
    "mini-smt-fs-060-hds-010-sds-010-sms-010-downstream-selector"
    "mini-smt-fs-060-hds-010-sds-010-sms-010-policy"
    "mini-smt-fs-060-hds-010-sds-010-sms-010-upstream-selector"
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
    "mini-smt-fs-370-hds-010-sds-010-sms-050-client-edge"
    "mini-smt-fs-370-hds-010-sds-010-sms-050-core-vlan4-client-dhcp-slaac"
    "mini-smt-fs-370-hds-010-sds-010-sms-050-downstream-selector"
    "mini-smt-fs-370-hds-010-sds-010-sms-050-policy"
    "mini-smt-fs-370-hds-010-sds-010-sms-050-upstream-selector"
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
    "mini-smt-fs-540-hds-010-sds-010-sms-020-access-dns"
    "mini-smt-fs-540-hds-010-sds-010-sms-020-downstream-selector"
    "mini-smt-fs-540-hds-010-sds-010-sms-020-policy"
    "mini-smt-fs-540-hds-010-sds-010-sms-020-resolver-node"
    "mini-smt-fs-540-hds-010-sds-010-sms-020-upstream-selector"
  ];
  nixosNodes = builtins.attrNames inventoryNixos.realization.nodes;
  clabNodes = builtins.attrNames inventoryClab.realization.nodes;
  nixosUplinks = inventoryNixos.deploymentHosts.s-router-nixos.uplinks;
  clabUplinks = inventoryClab.deploymentHosts.s-router-clab.uplinks;
  clabProvider = builtins.head inventoryClab.containerlab.labEmulation.requests;
  clientSite = activeIntentClients.control_plane_model.data."mini-smt"."FS-540-HDS-010-SDS-010-SMS-020";
  nixosClientEndpoint = clientSite.endpointAssignment."dns-resolver-nixos-client" or {};
  clabClientEndpoint = clientSite.endpointAssignment."dns-resolver-clab-client" or {};
in
  require (current.selection.layer == "SIT") "FS-540 SIT selector layer mismatch"
  && require (current.selection.selector == "FS-540-HDS-010-SDS-010") "FS-540 SIT selector id mismatch"
  && require (current.selection.sourceRoot == "GAMP/SIT/FS-540-HDS-010-SDS-010") "FS-540 SIT source root mismatch"
  && require (active.intent ? "mini-smt") "FS-540 SIT selection must install the row-local mini-SMT source"
  && require (active.intent."mini-smt" ? "FS-540-HDS-010-SDS-010-SMS-020") "FS-540 SIT must select the DNS resolver mini source"
  && require (manifest.tests."FS-540-HDS-010-SDS-010-SMS-020".maxRuntimeTargets == 5) "FS-540 DNS resolver mini cap must be five targets"
  && require (nixosNodes == expectedNodes) "FS-540 NixOS SIT must realize exactly the five-node DNS mini path"
  && require (clabNodes == expectedNodes) "FS-540 CLAB SIT must realize exactly the five-node DNS mini path"
  && require (builtins.all (name: inventoryNixos.realization.nodes.${name}.host == "s-router-nixos") nixosNodes) "FS-540 NixOS mini nodes must stay on s-router-nixos"
  && require (builtins.all (name: inventoryClab.realization.nodes.${name}.host == "s-router-clab") clabNodes) "FS-540 CLAB mini nodes must stay on s-router-clab"
  && require (inventoryHetz.realization.nodes == {}) "FS-540 Hetz SIT must be an explicit runtime NOP"
  && require (inventoryHetz.activeLabInventoryStub == {
    kind = "unsupported-runtime-host-stub";
    traceId = "FS-540-HDS-010-SDS-010-SMS-020";
    hostName = "s-router-hetz";
  }) "FS-540 Hetz SIT NOP must retain exact row and host provenance"
  && require (inventoryHetz.deploymentHosts.s-router-hetz.bridgeNetworks == {}) "FS-540 Hetz SIT NOP must not inherit row-local lab bridges"
  && require (inventoryHetz.deploymentHosts.s-router-hetz.uplinks.management.vlan == 2) "FS-540 Hetz SIT NOP must preserve only VLAN2 management"
  && require (inventoryClients.deploymentHosts ? s-router-test-clients) "FS-540 test-client SIT inventory must keep s-router-test-clients host substrate"
  && require (activeInventoryClients == inventoryClients) "FS-540 test-client SIT host inventory must preserve row-local client inventory"
  && require (inventoryClients.deploymentHosts.s-router-test-clients.uplinks.management.vlan == 2) "FS-540 test-client SIT inventory must preserve VLAN2 management"
  && require (activeIntentClients.control_plane_model.realization.nodes == { }) "FS-540 test-client SIT intent must not synthesize router realization nodes"
  && require (clientSite.runtimeTargets == { }) "FS-540 test-client SIT intent must not synthesize router runtime targets"
  && require (builtins.attrNames clientSite.endpointAssignment == [ "dns-resolver-clab-client" "dns-resolver-nixos-client" ]) "FS-540 test-client SIT intent must expose exactly the NixOS and CLAB DNS clients"
  && require (nixosClientEndpoint.owningSubstrate == "s-router-test-clients" && nixosClientEndpoint.mode == "static") "FS-540 NixOS client endpoint must target s-router-test-clients as a static endpoint"
  && require (clabClientEndpoint.owningSubstrate == "s-router-test-clients" && clabClientEndpoint.mode == "static") "FS-540 CLAB client endpoint must target s-router-test-clients as a static endpoint"
  && require (nixosClientEndpoint.bridge == "dns540n" && clabClientEndpoint.bridge == "dns540c") "FS-540 test-client SIT endpoints must use their modeled substrate bridges"
  && require (nixosClientEndpoint.static.address == "10.54.10.10" && nixosClientEndpoint.static.address6 == "fd42:540::10") "FS-540 NixOS client endpoint must carry its modeled dual-stack client addresses"
  && require (clabClientEndpoint.static.address == "10.54.10.10" && clabClientEndpoint.static.address6 == "fd42:540::10") "FS-540 CLAB client endpoint must carry its modeled dual-stack client addresses"
  && require (nixosClientEndpoint.static.gateway4 == "10.54.10.1" && nixosClientEndpoint.static.gateway6 == "fd42:540::1") "FS-540 NixOS client endpoint must point at the access resolver"
  && require (clabClientEndpoint.static.dnsServers == [ "10.54.10.1" "fd42:540::1" ]) "FS-540 CLAB client endpoint must use only the access resolver"
  && require (activeIntentClients.deploymentHosts.s-router-test-clients.uplinks.management.vlan == 2) "FS-540 test-client SIT intent must preserve VLAN2 management"
  && require (nixosUplinks ? testnet-vlan4 && nixosUplinks.testnet-vlan4.vlan == 4 && nixosUplinks.testnet-vlan4.mode == "vlan" && nixosUplinks.testnet-vlan4.ipv4.method == "dhcp") "FS-540 NixOS mini uplink must be explicit VLAN4 link with DHCP addressing, not untagged testnet"
  && require (clabUplinks ? testnet-vlan4 && clabUplinks.testnet-vlan4.vlan == 4 && clabUplinks.testnet-vlan4.mode == "vlan" && clabUplinks.testnet-vlan4.ipv4.method == "dhcp") "FS-540 CLAB mini uplink must be explicit VLAN4 link with DHCP addressing, not untagged testnet"
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
    "mini-smt-fs-800-hds-010-sds-020-sms-040-downstream-selector"
    "mini-smt-fs-800-hds-010-sds-020-sms-040-fabric-core"
    "mini-smt-fs-800-hds-010-sds-020-sms-040-policy"
    "mini-smt-fs-800-hds-010-sds-020-sms-040-pppoe-core"
    "mini-smt-fs-800-hds-010-sds-020-sms-040-provider-handoff-access-a"
    "mini-smt-fs-800-hds-010-sds-020-sms-040-upstream-selector"
  ];
  nixosNodes = builtins.attrNames inventoryNixos.realization.nodes;
  clabNodes = builtins.attrNames inventoryClab.realization.nodes;
in
  require (current.selection.layer == "SIT") "FS-800 provider route SIT selector layer mismatch"
  && require (current.selection.selector == "FS-800-HDS-010-SDS-020") "FS-800 provider route SIT selector id mismatch"
  && require (nixosNodes == expectedNodes) "FS-800 provider route NixOS SIT must realize exactly the six-node provider path"
  && require (clabNodes == expectedNodes) "FS-800 provider route CLAB SIT must realize exactly the six-node provider path"
  && require (builtins.all (name: inventoryNixos.realization.nodes.${name}.host == "s-router-nixos") nixosNodes) "FS-800 provider route NixOS mini nodes must stay on s-router-nixos"
  && require (builtins.all (name: inventoryClab.realization.nodes.${name}.host == "s-router-clab") clabNodes) "FS-800 provider route CLAB mini nodes must stay on s-router-clab"
  && require (inventoryHetz.realization.nodes == {}) "FS-800 provider route Hetz SIT must be an explicit runtime NOP"
  && require (inventoryHetz.activeLabInventoryStub == {
    kind = "unsupported-runtime-host-stub";
    traceId = "FS-800-HDS-010-SDS-020-SMS-040";
    hostName = "s-router-hetz";
  }) "FS-800 provider route Hetz SIT NOP must retain exact row and host provenance"
  && require (inventoryHetz.deploymentHosts.s-router-hetz.bridgeNetworks == {}) "FS-800 provider route Hetz SIT NOP must not inherit provider bridges"
  && require (inventoryHetz.deploymentHosts.s-router-hetz.uplinks.management.vlan == 2) "FS-800 provider route Hetz SIT NOP must preserve only VLAN2 management"
  && require (inventoryClients.deploymentHosts ? s-router-test-clients) "FS-800 provider route test-client inventory must keep s-router-test-clients host substrate"
  && require (((inventoryClients.realization or {}).nodes or {}) == {}) "FS-800 provider route must not render router nodes on s-router-test-clients"
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
