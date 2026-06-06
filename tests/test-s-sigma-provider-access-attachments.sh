#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-014-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${NETWORK_REPO_DIRECT_TEST_OK:-0}" != "1" && "${NETWORK_REPO_SWEEP:-0}" != "1" ]]; then
  echo "WARN: direct repo tests are partial; set NETWORK_REPO_DIRECT_TEST_OK=1 for intentional focused runs." >&2
fi

# shellcheck disable=SC2016
REPO_ROOT="${repo_root}" nix eval --impure --raw --expr '
  let
    root = builtins.getEnv "REPO_ROOT";
    intent = import (root + "/sat/intent.nix");
    inventory = import (root + "/sat/inventory.nix");
    table = import (root + "/sat/provider-access-fixture-table.nix");

    requiredTechnologies = {
      pppoeNixos = "pppoe";
      dhcpSlaacNixosClient = "dhcp-slaac";
      nebulaNixosUnderlay = "nebula";
      wireguardRemoteEgressHetz = "wireguard-remote-egress";
      wireguardHost128Hetz = "wireguard-host-128";
    };

    require = cond: msg: if cond then true else throw msg;

    attachmentNames = builtins.attrNames table.attachments;
    requiredNames = builtins.attrNames requiredTechnologies;

    row = name: table.attachments.${name};
    access = name: (row name).attachment;
    siteIntent = name: intent.esp.${(access name).site};
    accessSpace = name: (siteIntent name).profileManifest.accessSpaces.${(access name).accessSpace};
    runtimeNode = name: inventory.realization.nodes.${(access name).runtimeNode};
    tenantPort = name: (runtimeNode name).ports.${(access name).logicalInterface};

    forbiddenTopLevelFields = [
      "addressAuthority"
      "links"
      "policy"
      "policyAuthority"
      "routeAuthority"
      "routes"
      "topology"
      "topologyClass"
      "uplinks"
    ];

    rowIsConservative = name:
      let
        current = row name;
      in
        current.gampId == "FS-800-HDS-010-SDS-014-SMS-010"
        && current.technology == requiredTechnologies.${name}
        && current.sourceClass == "provider-access-realization-fact"
        && current.realizationAuthority == "inventory"
        && current.topologyAuthority == false
        && current.sideChannelAuthority == false
        && builtins.all (field: !(builtins.hasAttr field current)) forbiddenTopLevelFields;

    rowBindsOrdinaryAccessSpace = name:
      let
        currentAccess = access name;
        intentAttachment = (accessSpace name).attachment;
        port = tenantPort name;
      in
        currentAccess.kind == "access-space"
        && currentAccess.method == "tenant-access"
        && intentAttachment.method == currentAccess.method
        && intentAttachment.sourceNode == currentAccess.sourceNode
        && port.logicalInterface == currentAccess.logicalInterface
        && port.attach.kind == "bridge"
        && port.attach.bridge == currentAccess.accessSpace
        && !(port ? link)
        && !(port ? adapterName);

    overlayByName = site: overlayName:
      let
        matches = builtins.filter (overlay: overlay.name == overlayName) (intent.esp.${site}.transport.overlays or [ ]);
      in
        if matches == [ ] then throw "missing overlay ${site}.${overlayName}" else builtins.head matches;

    hasAdvertisement = name: kind:
      let
        advertisements = ((runtimeNode name).advertisements or { }).${kind} or { };
      in
        builtins.hasAttr ("tenant-" + (access name).accessSpace) advertisements;

    pppoeSourceOk =
      let
        source = row "pppoeNixos";
        scenario = inventory.controlPlane.providerAccess.scenarios.pppoeNixos;
      in
        source.realizationRef.providerScenarioId == scenario.scenarioId
        && scenario.fixtureRef.customerCoreNode == "nixos-router-core-isp-a"
        && scenario.substrate.ispHandoff.kind == "isolated-bridge";

    dhcpSlaacSourceOk =
      hasAdvertisement "dhcpSlaacNixosClient" "dhcp4"
      && hasAdvertisement "dhcpSlaacNixosClient" "dhcpv6"
      && hasAdvertisement "dhcpSlaacNixosClient" "ipv6Ra";

    nebulaSourceOk =
      let
        source = row "nebulaNixosUnderlay";
        intentOverlay = overlayByName "nixos" "east-west";
        inventoryOverlay = inventory.controlPlane.sites.esp.nixos.overlays.east-west;
      in
        source.realizationRef.provider == "nebula"
        && source.realizationRef.underlayAccess == { kind = "tenant"; name = "client"; }
        && intentOverlay.underlayAccess == source.realizationRef.underlayAccess
        && inventoryOverlay.provider == "nebula";

    wireguardRemoteEgressSourceOk =
      let
        source = row "wireguardRemoteEgressHetz";
        overlay = inventory.controlPlane.sites.esp.hetz.overlays.wg-routed64;
      in
        source.realizationRef.provider == "wireguard"
        && source.realizationRef.providerContract == "routed64"
        && overlay.provider == "wireguard"
        && overlay.wireguard.providerContract.id == "sat-wg-routed64"
        && overlay.wireguard.providerContract.provider.prefixAuthority == "provider-owned-prefix";

    wireguardHost128SourceOk =
      let
        source = row "wireguardHost128Hetz";
        overlay = inventory.controlPlane.sites.esp.hetz.overlays.wg-host128-egress;
      in
        source.realizationRef.provider == "wireguard"
        && source.realizationRef.providerContract == "hostOnly128Egress"
        && overlay.provider == "wireguard"
        && overlay.wireguard.providerContract.id == "sat-wg-host128-egress"
        && overlay.wireguard.providerContract.provider.prefixAuthority == "host-only-128"
        && builtins.elem "2001:db8:128::2/128" overlay.wireguard.providerContract.profile.generatedPeer.addresses;
  in
    if require (attachmentNames == requiredNames)
      "provider-access attachment table must split PPPoE, DHCP/SLAAC, Nebula, WireGuard remote-egress, and WireGuard host-/128 rows"
      && require (inventory.controlPlane.providerAccess.attachments == table.attachments)
        "inventory must expose provider-access attachment rows from the source table"
      && require (builtins.all rowIsConservative attachmentNames)
        "provider-access attachment rows must remain realization facts without topology or side-channel authority"
      && require (builtins.all rowBindsOrdinaryAccessSpace attachmentNames)
        "provider-access attachment rows must bind to ordinary access-space tenant attachments"
      && require pppoeSourceOk
        "PPPoE provider-access attachment must reference the existing PPPoE realization scenario without becoming topology"
      && require dhcpSlaacSourceOk
        "DHCP/SLAAC provider-access attachment must reference access advertisements as realization facts"
      && require nebulaSourceOk
        "Nebula provider-access attachment must use client underlay access as an ordinary tenant attachment"
      && require wireguardRemoteEgressSourceOk
        "WireGuard remote-egress attachment must remain an inventory provider contract on ordinary access space"
      && require wireguardHost128SourceOk
        "WireGuard host-/128 attachment must remain an inventory provider contract on ordinary access space"
    then "true"
    else "unreachable"
' >/dev/null

echo "PASS s-sigma-provider-access-attachments"
