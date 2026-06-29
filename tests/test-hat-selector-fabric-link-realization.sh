#!/usr/bin/env bash
# GAMP-ID: FS-260/FS-320
# GAMP-SCOPE: HAT source regression
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    inventories = [
      { label = "clab"; value = import (root + "/inventory-clab.nix"); }
      { label = "nixos"; value = import (root + "/inventory-nixos.nix"); }
    ];
    selectorNodeNames = [
      "clab-downstream-selector"
      "clab-upstream-selector"
      "nixos-downstream-selector"
      "nixos-upstream-selector"
    ];
    require = cond: msg: if cond then true else throw msg;
    linkPorts = node:
      builtins.filter
        (port: builtins.isString (port.link or null) && port.link != "")
        (builtins.attrValues (node.ports or { }));
    selectorTargets = inventory:
      builtins.filter
        (node: builtins.elem ((node.logicalNode or { }).name or null) selectorNodeNames)
        (builtins.attrValues (inventory.realization.nodes or { }));
    selectorLinkPorts = inventory:
      builtins.concatLists (map linkPorts (selectorTargets inventory));
    fabricLinkTargets = inventory: inventory.realization.fabricLinks or { };
    fabricLinks = inventory:
      let root = fabricLinkTargets inventory;
      in builtins.concatLists (map (targetName: builtins.attrValues root.${targetName}) (builtins.attrNames root));
    fabricLinkOk = fabricLink:
      (fabricLink.kind or null) == "selector-fabric-link"
      && builtins.isString (fabricLink.link or null)
      && (fabricLink.transport.hostFacing or true) == false
      && !(fabricLink ? adapterName)
      && !(fabricLink ? attach);
    explicitNonSelectorPortOk = inventory: nodeName: portName:
      let port = ((inventory.realization.nodes.${nodeName} or { }).ports or { }).${portName} or { };
      in
        (port.link or null) == portName
        && (port.attach.kind or null) == "bridge"
        && builtins.isString (port.attach.bridge or null);
    serviceInterfacePortOk = inventory: nodeName: portName:
      let port = ((inventory.realization.nodes.${nodeName} or { }).ports or { }).${portName} or { };
      in
        (port.serviceInterface or null) == portName
        && !(port ? link)
        && (port.attach.kind or null) == "bridge"
        && builtins.isString (port.attach.bridge or null);
    inventoryOk = item:
      let
        inventory = item.value;
        selectorPorts = selectorLinkPorts inventory;
        links = fabricLinks inventory;
        providerHandoffPortsOk =
          if item.label == "nixos" then
            serviceInterfacePortOk inventory
              "esp0xdeadbeef-site-a-nixos-core-testnet-host-isp"
              "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a"
            && serviceInterfacePortOk inventory
              "esp0xdeadbeef-site-a-nixos-provider-handoff-access-a"
              "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a"
            && serviceInterfacePortOk inventory
              "esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp"
              "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b"
            && serviceInterfacePortOk inventory
              "esp0xdeadbeef-site-a-nixos-provider-handoff-access-b"
              "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b"
          else if item.label == "clab" then
            serviceInterfacePortOk inventory
              "esp0xdeadbeef-site-b-clab-core-testnet-host-isp"
              "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a"
            && serviceInterfacePortOk inventory
              "esp0xdeadbeef-site-b-clab-provider-handoff-access-a"
              "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a"
            && serviceInterfacePortOk inventory
              "esp0xdeadbeef-site-b-clab-core-testnet-routed-isp"
              "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b"
            && serviceInterfacePortOk inventory
              "esp0xdeadbeef-site-b-clab-provider-handoff-access-b"
              "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b"
          else
            false;
      in
        require (selectorPorts == [ ])
          "${item.label} inventory must not expose selector p2p transit fanout as host-facing selector ports"
        && require (builtins.length links >= 68)
          "${item.label} inventory must preserve 68 selector p2p backing links as fabricLinks"
        && require (builtins.all fabricLinkOk links)
          "${item.label} selector fabricLinks must be non-host-facing selector-fabric-link records"
        && require (explicitNonSelectorPortOk inventory
          "esp0xdeadbeef-site-a-nixos-policy"
          "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client")
          "${item.label} inventory must preserve non-selector NixOS policy p2p port realization"
        && require (explicitNonSelectorPortOk inventory
          "esp0xdeadbeef-site-b-clab-policy"
          "p2p-clab-downstream-selector-clab-policy--access-clab-access-client")
          "${item.label} inventory must preserve non-selector CLAB policy p2p port realization"
        && require providerHandoffPortsOk
          "${item.label} inventory must preserve its provider handoff service-interface ports";
  in
    builtins.all inventoryOk inventories
' | grep -qx true

echo "PASS hat-selector-fabric-link-realization"
