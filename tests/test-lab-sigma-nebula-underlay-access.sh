#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"

if [[ "${NETWORK_REPO_DIRECT_TEST_OK:-0}" != "1" && "${NETWORK_REPO_SWEEP:-0}" != "1" ]]; then
  echo "WARN: direct repo tests are partial; set NETWORK_REPO_DIRECT_TEST_OK=1 for intentional focused runs." >&2
fi

export REPO_ROOT="$repo_root"

nix-instantiate --eval --strict --json --expr '
let
  intent = import (builtins.getEnv "REPO_ROOT" + "/GAMP/SAT/intent.nix");

  require = label: cond:
    if cond then true else throw label;

  getSite = site: intent.esp.${site};

  hasAccessNode = site: node: tenant:
    let
      n = (getSite site).topology.nodes.${node} or null;
    in
    n != null
    && (n.role or null) == "access"
    && builtins.any
      (attachment:
        (attachment.kind or null) == "tenant"
        && (attachment.name or null) == tenant)
      (n.attachments or []);

  hasTenantAttachment = site: node: tenant:
    let
      n = (getSite site).topology.nodes.${node} or null;
    in
    n != null
    && builtins.any
      (attachment:
        (attachment.kind or null) == "tenant"
        && (attachment.name or null) == tenant)
      (n.attachments or []);

  hasLink = site: a: b:
    builtins.any
      (link:
        builtins.length link == 2
        && (
          (builtins.elemAt link 0 == a && builtins.elemAt link 1 == b)
          || (builtins.elemAt link 0 == b && builtins.elemAt link 1 == a)
        ))
      ((getSite site).topology.links or []);

  overlay = site: builtins.head ((getSite site).transport.overlays or []);

  checkSite = site: core: access: expectsPayloadLink:
    let
      upstream =
        (if site == "hetz" then "hetz" else if site == "clab" then "clab" else "nixos")
        + "-router-upstream";
    in
    require "${site}: missing selected client access router for Nebula underlay WAN side"
      (hasAccessNode site access "client")
    && require "${site}: Nebula core underlay must be a host-like client tenant attachment"
      (hasTenantAttachment site core "client")
    && require "${site}: Nebula underlay must not be a p2p link to the selected access router"
      (! hasLink site core access)
    && require "${site}: Nebula payload core upstream link expectation mismatch"
      ((hasLink site core upstream) == expectsPayloadLink)
    && require "${site}: selected underlay access must still traverse downstream/policy fabric"
      (hasLink site access ((if site == "hetz" then "hetz" else if site == "clab" then "clab" else "nixos") + "-router-downstream"))
    && require "${site}: overlay must select client as explicit underlayAccess"
      ((overlay site).underlayAccess == { kind = "tenant"; name = "client"; });
in
  checkSite "nixos" "nixos-router-core-nebula" "nixos-router-access-client" true
  && checkSite "hetz" "hetz-router-nebula-core" "hetz-router-access-client" true
  && checkSite "clab" "clab-router-core-nebula" "clab-router-access-client" true
' >/dev/null

nix-instantiate --eval --strict --json --expr '
let
  inventory =
    import (builtins.getEnv "REPO_ROOT" + "/GAMP/SAT/getResolvedInventory.nix")
      { renderer = "nixos"; };

  require = label: cond:
    if cond then true else throw label;

  nodes = inventory.realization.nodes or { };
  hosts = inventory.deployment.hosts or { };

  hasAttr = name: attrs: builtins.hasAttr name attrs;

  portNames = nodeName: builtins.attrNames ((nodes.${nodeName} or { }).ports or { });
  bridgeNames = hostName: builtins.attrNames ((hosts.${hostName} or { }).bridgeNetworks or { });

  anyName = predicate: names: builtins.any predicate names;

  badPortName = name:
    name == "underlay-access-client"
    || name == "underlay-core-nebula"
    || name == "underlay-nebula-core";

  badLink = value:
    builtins.isString value
    && builtins.match ".*p2p-.*(access-client.*core-nebula|core-nebula.*access-client|access-client.*nebula-core|nebula-core.*access-client).*" value != null;

  nodeHasBadLink = nodeName:
    anyName
      (portName: badLink ((((nodes.${nodeName} or { }).ports or { }).${portName} or { }).link or null))
      (portNames nodeName);

  nodeHasBadPortName = nodeName: anyName badPortName (portNames nodeName);

  badBridge = name:
    builtins.match ".*(access-client.*core-nebula|core-nebula.*access-client|access-client.*nebula-core|nebula-core.*access-client).*" name != null;

  coreClientPortOk = nodeName:
    let
      port = ((nodes.${nodeName} or { }).ports or { }).tenant-client or null;
    in
    port != null
    && (port.logicalInterface or null) == "tenant-client"
    && (port.link or null) == null
    && (port.adapterName or null) == null
    && (port.attach.kind or null) == "bridge"
    && (port.attach.bridge or null) == "client"
    && (port.interface.name or null) == "client";

  payloadPortOk = nodeName: portName: expectedLink: expectedBridge:
    let
      port = ((nodes.${nodeName} or { }).ports or { }).${portName} or null;
    in
    port != null
    && (port.link or null) == expectedLink
    && (port.attach.kind or null) == "bridge"
    && (port.attach.bridge or null) == expectedBridge
    && (port.adapterName or null) != null;

  payloadPortAbsent = nodeName: portName:
    ! builtins.hasAttr portName ((nodes.${nodeName} or { }).ports or { });

  payloadBridgeAbsent = hostName: expectedBridge:
    ! builtins.hasAttr expectedBridge ((hosts.${hostName} or { }).bridgeNetworks or { });

  payloadPortsMatchExpectation =
    hostName: coreNode: upstreamNode: upstreamPayloadPort: expectedLink: expectedBridge: expectsPayloadLink:
    if expectsPayloadLink then
      payloadPortOk coreNode "upstream" expectedLink expectedBridge
      && payloadPortOk upstreamNode upstreamPayloadPort expectedLink expectedBridge
    else
      payloadPortAbsent coreNode "upstream"
      && payloadPortAbsent upstreamNode upstreamPayloadPort
      && payloadBridgeAbsent hostName expectedBridge;

  checkSite =
    site: hostName: accessNode: coreNode: upstreamNode: upstreamPayloadPort: expectedLink: expectedBridge: expectsPayloadLink:
    require "${site}: access client must not realize a p2p underlay port to Nebula core"
      (! nodeHasBadPortName accessNode && ! nodeHasBadLink accessNode)
    && require "${site}: Nebula core must be realized as a host-like client tenant attachment"
      (coreClientPortOk coreNode)
    && require "${site}: Nebula core must not retain access-underlay p2p ports"
      (! nodeHasBadPortName coreNode && ! nodeHasBadLink coreNode)
    && require "${site}: upstream selector must not retain access-underlay p2p ports"
      (! nodeHasBadPortName upstreamNode && ! nodeHasBadLink upstreamNode)
    && require "${site}: Nebula core payload link realization expectation mismatch"
      (payloadPortsMatchExpectation hostName coreNode upstreamNode upstreamPayloadPort expectedLink expectedBridge expectsPayloadLink)
    && require "${site}: host bridge inventory must not retain stale Nebula-core p2p bridges"
      (! anyName badBridge (bridgeNames hostName));
in
  checkSite "nixos" "s-router-test" "esp-nixos-router-access-client" "esp-nixos-router-core-nebula" "esp-nixos-router-upstream" "core-nebula" "p2p-nixos-router-core-nebula-nixos-router-upstream" "br-nixos-core-nebula-upstream" true
  && checkSite "hetz" "s-router-hetzner-anywhere" "esp-hetz-router-access-client" "esp-hetz-router-nebula-core" "esp-hetz-router-upstream" "nebula-core" "p2p-hetz-router-nebula-core-hetz-router-upstream" "br-hetz-nebula-core-upstream" true
  && checkSite "clab" "s-router-clab" "esp-clab-router-access-client" "esp-clab-router-core-nebula" "esp-clab-router-upstream" "core-nebula" "p2p-clab-router-core-nebula-clab-router-upstream" "br-clab-core-nebula-upstream" true
' >/dev/null

echo "PASS lab-sigma-nebula-underlay-access"
