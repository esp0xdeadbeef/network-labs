#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/labs/lab-s-sigma/s-router-test-three-site"

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
let
  intent = import ${lab_dir}/intent.nix;
  hetz = intent.esp.hetz.communicationContract;
  services = hetz.services or [ ];
  relations = hetz.relations or [ ];
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
in
  if dmzNebula == [ ] then
    throw \"lab-sigma Hetz intent missing dmz-nebula service; public Nebula 4242 must be modeled in intent, not only in runtime glue\"
  else if ! builtins.elem \"hetz-router-lighthouse\" ((builtins.head dmzNebula).providers or [ ]) then
    throw \"lab-sigma Hetz dmz-nebula service must be provided by hetz-router-lighthouse\"
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
