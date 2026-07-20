#!/usr/bin/env bash
# GAMP-ID: FS-380-HDS-020-SDS-010-SMS-050
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-internet-mode-verification-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-380-HDS-020-SDS-010-SMS-050\";
    entry = manifest.tests.\"FS-380-HDS-020-SDS-010-SMS-050\";
    rowRoot = ${repo_root}/GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-050;
    inventoryNixos = import (rowRoot + \"/inventory-nixos.nix\");
    inventoryClab = import (rowRoot + \"/inventory-clab.nix\");
    inventoryClients = import (rowRoot + \"/inventory-test-clients.nix\");
    clabProvider = builtins.head inventoryClab.containerlab.labEmulation.requests;
    record = builtins.head lab.internetModeRecords;
    require = cond: msg: if cond then true else throw msg;
    valid = mini.validators.internetModeVerification record;
    explicitAddressingOk = uplink:
      (uplink.bridge or null) != null
      && (uplink.parent or null) == \"eth0\"
      && (uplink.ipv4 or { }).enable == true
      && (uplink.ipv4 or { }).dhcp == true
      && (uplink.ipv4 or { }).method == \"dhcp\"
      && (uplink.ipv6 or { }).enable == true
      && (uplink.ipv6 or { }).acceptRA == true
      && (uplink.ipv6 or { }).dhcp == false
      && (uplink.ipv6 or { }).dhcpv6PD == false
      && (uplink.ipv6 or { }).method == \"slaac\";
    uplinksOk = uplinks:
      builtins.all
        (uplink:
          (uplink.vlan == 4 || uplink.vlan == 5)
          && uplink.mode == \"vlan\"
          && explicitAddressingOk uplink)
        (builtins.attrValues uplinks);
    uplinksNoVlan2 = uplinks:
      builtins.all (uplink: (uplink.vlan or null) != 2) (builtins.attrValues uplinks);
    recordUplinksUseOnlySemanticNames = uplinks:
      builtins.all
        (uplink:
          (uplink.name == \"isp\" || uplink.name == \"pppoe-provider\")
          && !(uplink ? vlan)
          && uplink.mode == \"dhcp\")
        uplinks;
    handoffOk = host: host.accessHandoff.kind == \"pppoe\" && host.accessHandoff.server == \"emulated-isp\";
    noRealizationNodes = inventory: ((inventory.realization or { }).nodes or { }) == { };
    skippedRecord = record // { skipInternetTest = true; };
    natRecord = record // { privateNat44 = [ { sourcePrefixes = [ \"10.80.10.0/24\" ]; } ]; };
    missingHandoffRecord = builtins.removeAttrs record [ \"accessHandoff\" ];
    opaqueHandoffRecord = record // { accessHandoff = record.accessHandoff // { kind = \"opaque\"; }; };
    vlan2Record = record // { upstream = { kind = \"emulated-isp\"; internetUplinks = [ { vlan = 2; mode = \"dhcp\"; } ]; }; };
    badNameRecord = record // { upstream = { kind = \"emulated-isp\"; internetUplinks = [ { name = \"unexpected-uplink\"; mode = \"dhcp\"; } ]; }; };
    routedWanRecord = record // { upstream = { kind = \"wan-core\"; internetUplinks = [ { name = \"isp\"; mode = \"dhcp\"; } ]; }; };
    staticModeRecord = record // { upstream = { kind = \"emulated-isp\"; internetUplinks = [ { name = \"isp\"; mode = \"static\"; } ]; }; };
    skippedCheck = mini.validators.internetModeVerification skippedRecord;
    natCheck = mini.validators.internetModeVerification natRecord;
    missingHandoffCheck = mini.validators.internetModeVerification missingHandoffRecord;
    opaqueHandoffCheck = mini.validators.internetModeVerification opaqueHandoffRecord;
    vlan2Check = mini.validators.internetModeVerification vlan2Record;
    badNameCheck = mini.validators.internetModeVerification badNameRecord;
    routedWanCheck = mini.validators.internetModeVerification routedWanRecord;
    staticModeCheck = mini.validators.internetModeVerification staticModeRecord;
  in
    require (lab.kind == \"mini-smt\")
      \"internet-mode lab must be a mini SMT\"
    && require (lab.traceId == \"FS-380-HDS-020-SDS-010-SMS-050\")
      \"internet-mode lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"internet-mode manifest must point at the same trace as the mini-lab\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"internet-mode manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"internet-mode manifest must use a row-specific intent source\"
    && require (entry.source.expectedRelationIds == lab.source.expectedRelationIds)
      \"internet-mode manifest must carry the same expected relation id as the mini-lab\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"internet-mode manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"internet-mode mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == [
      \"client-edge\"
      \"downstream-selector\"
      \"emulated-isp\"
      \"policy\"
      \"upstream-selector\"
    ])
      \"internet-mode mini SMT may start only the five-node staged path\"
    && require (lab.maxRuntimeTargets == 5)
      \"internet-mode mini SMT must stay capped at five runtime targets\"
    && require (lab.runtimeTargets.downstream-selector.role == \"downstream-selector\")
      \"internet-mode downstream-selector target must preserve staged role\"
    && require (lab.runtimeTargets.policy.role == \"policy\")
      \"internet-mode policy target must preserve staged role\"
    && require (lab.runtimeTargets.upstream-selector.role == \"upstream-selector\")
      \"internet-mode upstream-selector target must preserve staged role\"
    && require (builtins.length lab.internetModeRecords == 1)
      \"internet-mode mini SMT must test exactly one internet mode record\"
    && require (lab.testsOnly == [
      \"internet-mode-emulated-pppoe-handoff\"
      \"internet-mode-emulated-isp-upstream\"
      \"internet-mode-vlan4-vlan5-dhcp\"
      \"internet-mode-no-skip\"
      \"internet-mode-no-nat\"
      \"internet-mode-no-vlan2\"
    ])
      \"internet-mode mini SMT must name only the internet mode atom checks\"
    && require (builtins.elem \"s-router-clab\" lab.forbiddenScope)
      \"internet-mode mini SMT must forbid full s-router-clab scope\"
    && require (lab.runtimeTargets.client-edge.accessHandoff.kind == \"pppoe\")
      \"internet-mode client target must use an emulated PPPoE handoff\"
    && require ((builtins.head lab.runtimeTargets.emulated-isp.accessServices).kind == \"pppoe-server\")
      \"internet-mode provider target must expose an emulated PPPoE server\"
    && require (record.accessHandoff.kind == \"pppoe\" && record.accessHandoff.server == \"emulated-isp\" && record.accessHandoff.client == \"client-edge\")
      \"internet-mode record must exercise emulated PPPoE access instead of skipping internet\"
    && require ((record.upstream or {}).kind == \"emulated-isp\")
      \"internet-mode upstream must be an emulated ISP\"
    && require (recordUplinksUseOnlySemanticNames record.upstream.internetUplinks)
      \"internet-mode record must use semantic upstream names; VLAN4/VLAN5 realization belongs in inventory\"
    && require (uplinksOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks)
      \"internet-mode NixOS inventory must expose only VLAN4/VLAN5 links with DHCP addressing\"
    && require (handoffOk inventoryNixos.deploymentHosts.s-router-nixos)
      \"internet-mode NixOS inventory must define an emulated PPPoE handoff\"
    && require (uplinksNoVlan2 inventoryNixos.deploymentHosts.s-router-nixos.uplinks)
      \"internet-mode NixOS inventory must not expose VLAN2\"
    && require (uplinksOk inventoryClab.deploymentHosts.s-router-clab.uplinks)
      \"internet-mode CLAB inventory must expose only VLAN4/VLAN5 links with DHCP addressing\"
    && require (handoffOk inventoryClab.deploymentHosts.s-router-clab)
      \"internet-mode CLAB inventory must define an emulated PPPoE handoff\"
    && require (uplinksNoVlan2 inventoryClab.deploymentHosts.s-router-clab.uplinks)
      \"internet-mode CLAB inventory must not expose VLAN2\"
    && require (inventoryClab.containerlab.capabilities.labEmulation == true)
      \"internet-mode CLAB inventory must declare explicit lab-emulation capability\"
    && require (inventoryClab.containerlab.labEmulation.scope == \"harness\")
      \"internet-mode CLAB fake provider must be harness-scoped\"
    && require (builtins.length inventoryClab.containerlab.labEmulation.requests == 1)
      \"internet-mode CLAB inventory must declare exactly one fake-provider request\"
    && require (clabProvider.providerEmulationMode == \"fake-provider\" && clabProvider.handoffVlan == 11 && clabProvider.liveUpstreamVlan == 4)
      \"internet-mode CLAB fake provider must bind provider handoff VLAN11 and live upstream VLAN4 explicitly\"
    && require (clabProvider.dhcp4.address == \"10.20.0.1/24\" && clabProvider.dhcp4.router == \"10.20.0.1\" && clabProvider.dhcp4.clientAddress == \"10.20.0.20\" && clabProvider.dhcp4.rangeStart == \"10.20.0.20\" && clabProvider.dhcp4.rangeEnd == \"10.20.0.99\" && clabProvider.dhcp4.leaseTime == \"5m\" && clabProvider.dhcp4.sourcePrefix == \"10.20.0.0/24\")
      \"internet-mode CLAB fake provider must declare explicit DHCPv4 service parameters\"
    && require (clabProvider.nat44.enabled == true && clabProvider.nat44.sourcePrefix == \"10.20.0.0/24\")
      \"internet-mode CLAB fake provider must declare explicit NAT44 source prefix\"
    && require (clabProvider.handoffVlan != 2 && clabProvider.liveUpstreamVlan != 2)
      \"internet-mode CLAB fake provider must not use VLAN2\"
    && require (inventoryClients.deploymentHosts ? s-router-test-clients)
      \"internet-mode test-clients inventory must keep the s-router-test-clients host substrate\"
    && require (uplinksOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks)
      \"internet-mode test-clients inventory must expose only VLAN4/VLAN5 links with DHCP addressing\"
    && require (handoffOk inventoryClients.deploymentHosts.s-router-test-clients)
      \"internet-mode test-clients inventory must define an emulated PPPoE handoff\"
    && require (uplinksNoVlan2 inventoryClients.deploymentHosts.s-router-test-clients.uplinks)
      \"internet-mode test-clients inventory must not expose VLAN2 as dataplane\"
    && require (noRealizationNodes inventoryClients)
      \"internet-mode test-clients inventory must not synthesize router realization nodes\"
    && require (valid.ok && valid.diagnostic == null)
      \"valid internet mode record must pass\"
    && require (!skippedCheck.ok && skippedCheck.diagnostic == \"internet-test-skip-not-allowed\")
      \"internet-mode mini SMT must reject skipped internet coverage\"
    && require (!natCheck.ok && natCheck.diagnostic == \"nat-not-allowed\")
      \"internet-mode mini SMT must reject NAT\"
    && require (!missingHandoffCheck.ok && missingHandoffCheck.diagnostic == \"missing-emulated-access-handoff\")
      \"internet-mode mini SMT must require an emulated access handoff\"
    && require (!opaqueHandoffCheck.ok && opaqueHandoffCheck.diagnostic == \"unsupported-emulated-access-handoff\")
      \"internet-mode mini SMT must reject opaque access handoffs\"
    && require (!vlan2Check.ok && vlan2Check.diagnostic == \"vlan2-not-allowed\")
      \"internet-mode mini SMT must reject VLAN2\"
    && require (!badNameCheck.ok && badNameCheck.diagnostic == \"internet-uplink-not-allowed\")
      \"internet-mode mini SMT must reject unexpected semantic upstream names\"
    && require (!routedWanCheck.ok && routedWanCheck.diagnostic == \"upstream-not-emulated-isp\")
      \"internet-mode mini SMT must reject non-emulated-ISP upstreams\"
    && require (!staticModeCheck.ok && staticModeCheck.diagnostic == \"internet-uplink-must-use-dhcp\")
      \"internet-mode mini SMT must require DHCP mode\"
" >/dev/null || fail "mini SMT internet mode verification contract failed"

echo "PASS active-lab-mini-smt-internet-mode-verification-only"
