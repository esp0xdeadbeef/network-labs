#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/labs/lab-s-sigma/s-router-test-three-site"

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
