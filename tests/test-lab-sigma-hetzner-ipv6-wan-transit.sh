#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
let
  inventory = import ${lab_dir}/getInventory.nix { renderer = \"nixos\"; };
  host = inventory.deployment.hosts.s-router-hetzner-anywhere;
  nodes = inventory.realization.nodes;
  core = nodes.esp-hetz-router-core;
  wan = core.ports.wan.interface;
  hostWan = host.uplinks.wan;
  hasPrefix = prefix: value: builtins.match (prefix + \".*\") value != null;
  hostWanV6 = builtins.filter (hasPrefix \"fd\") (hostWan.hostAddresses or [ ]);
  coreWanV6 = wan.addr6 or \"\";
  coreV6Routes = wan.routes.ipv6 or [ ];
  defaultRoutes = builtins.filter (route: route.prefix or \"\" == \"::/0\") coreV6Routes;
  v6Gateway = if defaultRoutes == [ ] then \"\" else (builtins.head defaultRoutes).via or \"\";
in
  if hostWan.bridge or \"\" != \"br-wan\" then
    throw \"lab-sigma Hetzner NixOS inventory must keep the site-c WAN on br-wan\"
  else if hostWanV6 == [ ] then
    throw \"lab-sigma Hetzner NixOS inventory must model a private IPv6 host address on br-wan; live hostile GUA egress otherwise reaches c-router-core and dies without an IPv6 WAN next-hop\"
  else if coreWanV6 == \"\" then
    throw \"lab-sigma c-router-core WAN inventory must model a private IPv6 address on br-wan; do not hardcode public delegated prefixes here\"
  else if defaultRoutes == [ ] then
    throw \"lab-sigma c-router-core WAN inventory must model ::/0 via the private br-wan IPv6 host address for routed hostile GUA egress\"
  else if !(hasPrefix \"fd\" v6Gateway) then
    throw \"lab-sigma c-router-core WAN IPv6 default gateway must be private ULA br-wan transit, not a public provider address\"
  else
    true
" >/dev/null

echo "PASS lab-sigma-hetzner-ipv6-wan-transit"
