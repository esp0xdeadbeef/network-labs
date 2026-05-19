#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/labs/lab-s-sigma/s-router-test-three-site"

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
let
  intent = import ${lab_dir}/intent.nix;
  inventory = import ${lab_dir}/getInventory.nix { renderer = \"nixos\"; };
  hetz = intent.esp.hetz.communicationContract;
  sites = inventory.controlPlane.sites.esp;
  services = hetz.services or [ ];
  relations = hetz.relations or [ ];
  hetzOverlay = sites.hetz.overlays.east-west;
  nixosOverlay = sites.nixos.overlays.east-west;
  clabOverlay = sites.clab.overlays.east-west;
  relayService = hetzOverlay.runtimeNodes.hetz-router-nebula-core.service or { };
  findService = name:
    builtins.filter (svc: (svc.name or null) == name) services;
  findWanNebula = builtins.filter
    (rel:
      (rel.id or null) == \"allow-wan-to-dmz-nebula\"
      && (rel.action or null) == \"allow\"
      && (rel.trafficType or null) == \"nebula\"
      && (rel.from.kind or null) == \"external\"
      && builtins.elem \"wan\" (rel.from.uplinks or [ ])
      && (rel.to.kind or null) == \"service\"
      && (rel.to.name or null) == \"dmz-nebula\")
    relations;
  dmzNebula = findService \"dmz-nebula\";
  hasRuntimeClient = overlay: nodeName:
    let
      runtimeNode = (overlay.runtimeNodes or { }).\${nodeName} or null;
    in
      builtins.isAttrs runtimeNode
      && ((runtimeNode.container or { }).targetContainer or nodeName) == nodeName
      && ((runtimeNode.container or { }).profile or \"\") == \"core-router-nebula\";
in
  if dmzNebula == [ ] then
    throw \"lab-sigma Hetz intent missing dmz-nebula service; public Nebula 4242 must be modeled in intent, not only in runtime glue\"
  else if ! builtins.elem \"hetz-router-lighthouse\" ((builtins.head dmzNebula).providers or [ ]) then
    throw \"lab-sigma Hetz dmz-nebula service must be provided by hetz-router-lighthouse\"
  else if (hetzOverlay.nebula.lighthouse.node or null) != \"hetz-router-lighthouse\" then
    throw \"lab-sigma Hetz overlay lighthouse must be the DMZ service node hetz-router-lighthouse\"
  else if (hetzOverlay.runtimeNodes.hetz-router-lighthouse.relay.amRelay or false) then
    throw \"lab-sigma Hetz DMZ lighthouse must not be the core relay/client node\"
  else if !((hetzOverlay.runtimeNodes.hetz-router-nebula-core.relay.amRelay or false)) then
    throw \"lab-sigma Hetz overlay core must be the modeled Nebula relay/client node\"
  else if (relayService.port or null) != 4243 then
    throw \"lab-sigma Hetz overlay core relay must listen on its own explicit public runtime port\"
  else if (relayService.publicEndpoints or [ ]) != [
    {
      endpointSourceFile = \"/run/secrets/hetzner-public-ipv4\";
      port = 4243;
    }
  ] then
    throw \"lab-sigma Hetz overlay core relay must expose an explicit SOPS-backed public runtime endpoint\"
  else if !hasRuntimeClient hetzOverlay \"hetz-router-nebula-core\" then
    throw \"lab-sigma Hetz overlay core must have its own runtime client profile targeted at hetz-router-nebula-core\"
  else if !hasRuntimeClient nixosOverlay \"nixos-router-core-nebula\" then
    throw \"lab-sigma NixOS overlay core must have its own runtime client profile targeted at nixos-router-core-nebula\"
  else if !hasRuntimeClient clabOverlay \"clab-router-core-nebula\" then
    throw \"lab-sigma CLAB overlay core must have its own runtime client profile targeted at clab-router-core-nebula\"
  else if findWanNebula == [ ] then
    throw \"lab-sigma Hetz intent missing allow-wan-to-dmz-nebula relation for trafficType nebula on WAN\"
  else
    true
" >/dev/null

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
let
  sops = import ${lab_dir}/getInventorySops.nix;
  publicEndpoint = sops.runtimeFacts.publicEndpoint or { };
  lighthouse = publicEndpoint.lighthouseIpv4Secret or null;
  core = publicEndpoint.nebulaCoreIpv4Secret or null;
in
  if !(builtins.isString lighthouse && lighthouse != \"\") then
    throw \"lab-sigma Nebula public endpoint contract missing publicEndpoint.lighthouseIpv4Secret; the lighthouse must have an explicit SOPS-backed public IPv4 endpoint\"
  else if !(builtins.isString core && core != \"\") then
    throw \"lab-sigma Nebula public endpoint contract missing publicEndpoint.nebulaCoreIpv4Secret; the remote c-core must have an explicit SOPS-backed public IPv4 endpoint\"
  else if lighthouse == core then
    throw \"lab-sigma Nebula public endpoint contract invalid: lighthouseIpv4Secret and nebulaCoreIpv4Secret must be distinct so both peers can use UDP 4242 without public tuple collision\"
  else
    true
" >/dev/null

echo "PASS lab-sigma-nebula-public-endpoints"
