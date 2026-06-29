#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-030-SDS-010-SMS-041
# GAMP-SCOPE: active-lab source fixture proof for renderer fail-closed bridge fields; not HAT/SAT live evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-720-HDS-030-SDS-010-SMS-041"

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

REPO_ROOT="${repo_root}" nix eval --impure --raw --expr '
  let
    root = builtins.getEnv "REPO_ROOT";
    nixosInventory = import (root + "/GAMP/HAT/emulated-isp-residential-testnet/inventory-nixos.nix");
    clabInventory = import (root + "/GAMP/HAT/emulated-isp-residential-testnet/inventory-clab.nix");
    traceId = "FS-720-HDS-030-SDS-010-SMS-041";

    require = cond: msg: if cond then true else throw msg;

    tenantSurfaceOk = inventory: host: nodeKey: expectedLogicalNode: expectedLogicalInterface: expectedBridge: expectedRuntimeInterface:
      let
        node =
          if builtins.hasAttr nodeKey inventory.realization.nodes
          then builtins.getAttr nodeKey inventory.realization.nodes
          else { };
        port =
          if builtins.hasAttr expectedLogicalInterface (node.ports or { })
          then builtins.getAttr expectedLogicalInterface node.ports
          else { };
        hostBridgeNetworks = inventory.deployment.hosts.${host}.bridgeNetworks or { };
        bridge = port.attach.bridge or null;
        runtimeName = port.interface.name or null;
      in
        require (node.host == host)
          "${traceId}: ${nodeKey} host mismatch"
        && require (node.logicalNode.name == expectedLogicalNode)
          "${traceId}: ${nodeKey} logical node mismatch"
        && require (builtins.hasAttr expectedLogicalInterface (node.ports or { }))
          "${traceId}: ${nodeKey} must expose explicit tenant port ${expectedLogicalInterface}"
        && require ((port.logicalInterface or null) == expectedLogicalInterface)
          "${traceId}: ${nodeKey}.${expectedLogicalInterface} logicalInterface mismatch"
        && require (bridge == expectedBridge)
          "${traceId}: ${nodeKey}.${expectedLogicalInterface} attach.bridge mismatch"
        && require (builtins.hasAttr expectedBridge hostBridgeNetworks)
          "${traceId}: ${nodeKey}.${expectedLogicalInterface} bridge ${expectedBridge} must exist in ${host} bridgeNetworks"
        && require (runtimeName == expectedRuntimeInterface)
          "${traceId}: ${nodeKey}.${expectedLogicalInterface} runtime interface mismatch"
        && require (builtins.stringLength runtimeName <= 15)
          "${traceId}: ${nodeKey}.${expectedLogicalInterface} runtime interface must be Linux-safe";
  in
    if tenantSurfaceOk
        nixosInventory
        "s-router-nixos"
        "esp0xdeadbeef-site-a-nixos-core-nebula"
        "nixos-core-nebula"
        "tenant-iot"
        "iot"
        "tenant-iot"
      && tenantSurfaceOk
        nixosInventory
        "s-router-nixos"
        "esp0xdeadbeef-site-a-nixos-core-wireguard-host128"
        "nixos-core-wireguard-host128"
        "tenant-iot"
        "iot"
        "tenant-iot"
      && tenantSurfaceOk
        nixosInventory
        "s-router-nixos"
        "esp0xdeadbeef-site-a-nixos-core-wireguard-remote-egress"
        "nixos-core-wireguard-remote-egress"
        "tenant-iot"
        "iot"
        "tenant-iot"
      && tenantSurfaceOk
        nixosInventory
        "s-router-nixos"
        "esp0xdeadbeef-site-a-nixos-core-testnet-host-isp"
        "nixos-core-testnet-host-isp"
        "tenant-provider-handoff-a"
        "provider-handoff-a"
        "prov-core-a"
      && tenantSurfaceOk
        nixosInventory
        "s-router-nixos"
        "esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp"
        "nixos-core-testnet-routed-isp"
        "tenant-provider-handoff-b"
        "provider-handoff-b"
        "prov-core-b"
      && tenantSurfaceOk
        clabInventory
        "s-router-clab"
        "esp0xdeadbeef-site-b-clab-core-nebula"
        "clab-core-nebula"
        "tenant-iot"
        "iot"
        "tenant-iot"
      && tenantSurfaceOk
        clabInventory
        "s-router-clab"
        "esp0xdeadbeef-site-b-clab-core-wireguard-host128"
        "clab-core-wireguard-host128"
        "tenant-iot"
        "iot"
        "tenant-iot"
      && tenantSurfaceOk
        clabInventory
        "s-router-clab"
        "esp0xdeadbeef-site-b-clab-core-wireguard-remote-egress"
        "clab-core-wireguard-remote-egress"
        "tenant-iot"
        "iot"
        "tenant-iot"
      && tenantSurfaceOk
        clabInventory
        "s-router-clab"
        "esp0xdeadbeef-site-b-clab-core-testnet-host-isp"
        "clab-core-testnet-host-isp"
        "tenant-provider-handoff-a"
        "provider-handoff-a"
        "prov-core-a"
      && tenantSurfaceOk
        clabInventory
        "s-router-clab"
        "esp0xdeadbeef-site-b-clab-core-testnet-routed-isp"
        "clab-core-testnet-routed-isp"
        "tenant-provider-handoff-b"
        "provider-handoff-b"
        "prov-core-b"
    then "true"
    else "unreachable"
' >/dev/null || fail "active-lab tenant bridge source validation failed"

echo "PASS ${trace_id}"
