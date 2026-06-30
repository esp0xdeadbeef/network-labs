#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-902
# GAMP-SCOPE: active-lab mini runtime SMT; NixOS renderer-input p2p materialization; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
nixos_renderer_root="${NETWORK_RENDERER_NIXOS_ROOT:-${repo_root}/../network-renderer-nixos}"
cpm_path="${MINI_SMT_CPM_PATH:-${repo_root}/GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-p2p-cpm.nix}"

fail() {
  echo "FAIL active-lab-mini-smt-runtime-nixos-p2p-renderer-input: $*" >&2
  exit 1
}

[[ -d "${nixos_renderer_root}" ]] || fail "missing network-renderer-nixos repo at ${nixos_renderer_root}"
[[ -f "${cpm_path}" ]] || fail "missing CPM fixture at ${cpm_path}"

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
  let
    nixosRenderer = builtins.getFlake \"path:${nixos_renderer_root}\";
    system = builtins.currentSystem;
    cpm = import ${cpm_path};
    host = nixosRenderer.libBySystem.\${system}.renderer.buildHostFromControlPlane {
      controlPlaneOut = cpm;
      selector = \"s-router-nixos\";
      inherit system;
    };
    rendered = host.renderedHost;
    traceId = cpm.control_plane_model.meta.traceId;
    layerEntry = cpm.control_plane_model.meta.layerEntry;
    warningCodes = map (warning: warning.code) layerEntry.warnings;
    containerNames = builtins.attrNames (rendered.containers or { });
    bridgeNames = builtins.attrNames (rendered.bridges or { });
    attachTargets = rendered.attachTargets or [ ];
    hasValue = value: list: builtins.elem value list;
    routeMatches = route: dst: via:
      (route.dst or route.Destination or null) == dst
      && ((route.via4 or route.via6 or route.Gateway or null) == via);
    targetFor = unit:
      let matches = builtins.filter (target: target.unitName == unit) attachTargets;
      in if matches == [ ] then null else builtins.head matches;
    edgeA = targetFor \"acme::lab::edge-a\";
    edgeB = targetFor \"acme::lab::edge-b\";
    edgeAVeths = builtins.attrValues (rendered.containers.edge-a.extraVeths or { });
    edgeBVeths = builtins.attrValues (rendered.containers.edge-b.extraVeths or { });
    edgeABridge = if edgeAVeths == [ ] then null else (builtins.head edgeAVeths).hostBridge or null;
    edgeBBridge = if edgeBVeths == [ ] then null else (builtins.head edgeBVeths).hostBridge or null;
    renderedBridge = (rendered.bridges.\"rt--p2p--bridge--edge-a-b\" or { }).renderedName or null;
    edgeAIface = cpm.control_plane_model.data.acme.lab.runtimeTargets.edge-a.effectiveRuntimeRealization.interfaces.edge-a-b;
    edgeBIface = cpm.control_plane_model.data.acme.lab.runtimeTargets.edge-b.effectiveRuntimeRealization.interfaces.edge-a-b;
    allocationIsExpected = allocation:
      allocation.source == \"control-plane-model\"
      && allocation.tableId == 2200
      && allocation.priority == 5000
      && allocation.tableRulePriority == 5001
      && allocation.dynamicRulePriority == 5002
      && allocation.mainSuppressPriority == 5003;
    p2pInterfaceClassOk = iface:
      iface.explicit.explicitTransit == true
      && iface.explicit.explicitWan == false
      && iface.explicit.explicitLocalAdapter == false
      && iface.interfaceClass.edgeFacing == false
      && iface.interfaceClass.fabricFacing == false
      && iface.interfaceClass.exitFacing == false
      && iface.interfaceClass.coreFacing == false
      && iface.interfaceClass.overlay == false
      && iface.interfaceClass.coreTransit == false;
    require = cond: msg: if cond then true else throw msg;
  in
    require (traceId == \"FS-166-HDS-010-SDS-010-SMS-902\")
      \"p2p runtime CPM must carry the mini runtime p2p trace id\"
    && require (layerEntry.entryBoundary == \"renderer-input\")
      \"p2p runtime CPM must be renderer-input boundary\"
    && require (warningCodes == [
      \"WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE\"
      \"WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER\"
      \"WARN_LAYER_ENTRY_SKIPS_NFM\"
      \"WARN_LAYER_ENTRY_SKIPS_CPM\"
    ])
      \"p2p runtime CPM must carry all skipped-stage warnings\"
    && require (containerNames == [ \"edge-a\" \"edge-b\" ])
      \"p2p mini runtime must render exactly edge-a and edge-b\"
    && require (bridgeNames == [ \"rt--p2p--bridge--edge-a-b\" ])
      \"p2p mini runtime must render exactly one p2p bridge\"
    && require (builtins.length attachTargets == 2)
      \"p2p mini runtime must render exactly two attach targets\"
    && require (edgeA != null && edgeB != null)
      \"p2p mini runtime must expose attach targets for both edge containers\"
    && require (hasValue \"192.0.2.0/31\" edgeA.addresses && hasValue \"192.0.2.1/31\" edgeB.addresses)
      \"p2p mini runtime must preserve both IPv4 p2p endpoint addresses\"
    && require (hasValue \"2001:db8:9000::/127\" edgeA.addresses && hasValue \"2001:db8:9000::1/127\" edgeB.addresses)
      \"p2p mini runtime must preserve both IPv6 p2p endpoint addresses\"
    && require (builtins.any (route: routeMatches route \"10.20.2.0/24\" \"192.0.2.1\") edgeA.routes)
      \"edge-a must carry the route atom via edge-b\"
    && require (builtins.any (route: routeMatches route \"10.20.1.0/24\" \"192.0.2.0\") edgeB.routes)
      \"edge-b must carry the route atom via edge-a\"
    && require (edgeABridge == renderedBridge && edgeBBridge == renderedBridge)
      \"both containers must attach their veth to the same rendered p2p bridge\"
    && require (allocationIsExpected edgeAIface.policyRoutingAllocation && allocationIsExpected edgeBIface.policyRoutingAllocation)
      \"p2p renderer-input fixture must carry explicit CPM policyRoutingAllocation for both endpoints\"
    && require (p2pInterfaceClassOk edgeAIface && p2pInterfaceClassOk edgeBIface)
      \"p2p renderer-input fixture must carry explicit CPM interfaceClass for both endpoints\"
" >/dev/null || fail "NixOS p2p renderer-input contract failed"

echo "PASS active-lab-mini-smt-runtime-nixos-p2p-renderer-input"
