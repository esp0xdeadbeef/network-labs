#!/usr/bin/env bash
# GAMP-ID: FS-380-HDS-020-SDS-010-SMS-050
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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
    entry = manifest.tests.\"internet-mode-verification\";
    rowRoot = ${repo_root}/GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-050;
    inventoryNixos = import (rowRoot + \"/inventory-nixos.nix\");
    inventoryClab = import (rowRoot + \"/inventory-clab.nix\");
    inventoryClients = import (rowRoot + \"/inventory-test-clients.nix\");
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
        (uplink: (uplink.vlan == 4 || uplink.vlan == 5) && uplink.mode == \"dhcp\" && explicitAddressingOk uplink)
        (builtins.attrValues uplinks);
    uplinksNoVlan2 = uplinks:
      builtins.all (uplink: (uplink.vlan or null) != 2) (builtins.attrValues uplinks);
    handoffOk = host: host.accessHandoff.kind == \"pppoe\" && host.accessHandoff.server == \"emulated-isp\";
    skippedRecord = record // { skipInternetTest = true; };
    natRecord = record // { privateNat44 = [ { sourcePrefixes = [ \"10.80.10.0/24\" ]; } ]; };
    missingHandoffRecord = builtins.removeAttrs record [ \"accessHandoff\" ];
    opaqueHandoffRecord = record // { accessHandoff = record.accessHandoff // { kind = \"opaque\"; }; };
    vlan2Record = record // { upstream = { kind = \"emulated-isp\"; internetUplinks = [ { vlan = 2; mode = \"dhcp\"; } ]; }; };
    routedWanRecord = record // { upstream = { kind = \"wan-core\"; internetUplinks = [ { vlan = 4; mode = \"dhcp\"; } ]; }; };
    staticModeRecord = record // { upstream = { kind = \"emulated-isp\"; internetUplinks = [ { vlan = 4; mode = \"static\"; } ]; }; };
    skippedCheck = mini.validators.internetModeVerification skippedRecord;
    natCheck = mini.validators.internetModeVerification natRecord;
    missingHandoffCheck = mini.validators.internetModeVerification missingHandoffRecord;
    opaqueHandoffCheck = mini.validators.internetModeVerification opaqueHandoffRecord;
    vlan2Check = mini.validators.internetModeVerification vlan2Record;
    routedWanCheck = mini.validators.internetModeVerification routedWanRecord;
    staticModeCheck = mini.validators.internetModeVerification staticModeRecord;
  in
    require (lab.kind == \"mini-smt\")
      \"internet-mode lab must be a mini SMT\"
    && require (lab.traceId == \"FS-380-HDS-020-SDS-010-SMS-050\")
      \"internet-mode lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"internet-mode manifest must point at the same trace as the mini-lab\"
    && require (entry.script == \"tests/test-active-lab-mini-smt-internet-mode-verification-only.sh\")
      \"internet-mode manifest must point at this focused script\"
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
    && require (builtins.attrNames lab.runtimeTargets == [ \"client-edge\" \"emulated-isp\" ])
      \"internet-mode mini SMT may start only client-edge and emulated-isp\"
    && require (lab.maxRuntimeTargets == 2)
      \"internet-mode mini SMT must stay capped at two runtime targets\"
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
    && require (builtins.all (uplink: (uplink.vlan == 4 || uplink.vlan == 5) && uplink.mode == \"dhcp\") record.upstream.internetUplinks)
      \"internet-mode upstream may only use VLAN4/VLAN5 DHCP uplinks\"
    && require (uplinksOk inventoryNixos.deploymentHosts.s-router-nixos.uplinks)
      \"internet-mode NixOS inventory must expose only VLAN4/VLAN5 DHCP uplinks\"
    && require (handoffOk inventoryNixos.deploymentHosts.s-router-nixos)
      \"internet-mode NixOS inventory must define an emulated PPPoE handoff\"
    && require (uplinksNoVlan2 inventoryNixos.deploymentHosts.s-router-nixos.uplinks)
      \"internet-mode NixOS inventory must not expose VLAN2\"
    && require (uplinksOk inventoryClab.deploymentHosts.s-router-clab.uplinks)
      \"internet-mode CLAB inventory must expose only VLAN4/VLAN5 DHCP uplinks\"
    && require (handoffOk inventoryClab.deploymentHosts.s-router-clab)
      \"internet-mode CLAB inventory must define an emulated PPPoE handoff\"
    && require (uplinksNoVlan2 inventoryClab.deploymentHosts.s-router-clab.uplinks)
      \"internet-mode CLAB inventory must not expose VLAN2\"
    && require (uplinksOk inventoryClients.deploymentHosts.s-router-test-clients.uplinks)
      \"internet-mode test-clients inventory must expose only VLAN4/VLAN5 DHCP uplinks\"
    && require (handoffOk inventoryClients.deploymentHosts.s-router-test-clients)
      \"internet-mode test-clients inventory must define an emulated PPPoE handoff\"
    && require (uplinksNoVlan2 inventoryClients.deploymentHosts.s-router-test-clients.uplinks)
      \"internet-mode test-clients inventory must not expose VLAN2\"
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
    && require (!routedWanCheck.ok && routedWanCheck.diagnostic == \"upstream-not-emulated-isp\")
      \"internet-mode mini SMT must reject non-emulated-ISP upstreams\"
    && require (!staticModeCheck.ok && staticModeCheck.diagnostic == \"internet-uplink-must-use-dhcp\")
      \"internet-mode mini SMT must require DHCP mode\"
" >/dev/null || fail "mini SMT internet mode verification contract failed"

echo "PASS active-lab-mini-smt-internet-mode-verification-only"
