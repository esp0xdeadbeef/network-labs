#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/labs/lab-s-sigma/s-router-test-three-site"

status=0
missing_paths=()

missing() {
  local path="$1"
  missing_paths+=("${path}")
  status=1
}

report_missing() {
  cat >&2 <<EOF
FATAL network-labs lab-s-sigma runtime contract is not implemented yet.

missing:
EOF
  printf '  - %s\n' "${missing_paths[@]}" >&2
  cat >&2 <<'EOF'

This red failure may be removed only after network-labs owns the prod-like
s-router-test-three-site lab as labs/lab-s-sigma/s-router-test-three-site and
exposes explicit staging entrypoints for:

  - getIntent or getCompilerInput: plain semantic compiler input
  - getInventory: plain non-secret realization facts
  - getInventorySops: encrypted/test-injected realization facts
  - getResolvedInventory: getInventory merged with getInventorySops

The lab guard must also fail hard before compile/rebuild when plain lab files
contain real public IPv4/GUA IPv6 values, deployment MACs classified secret,
overlay client addresses classified secret, or raw route/firewall/bridge glue.
EOF
}

[[ -d "${lab_dir}" ]] || missing "${lab_dir}/"
[[ -f "${lab_dir}/flake.nix" ]] || missing "${lab_dir}/flake.nix"
[[ -f "${lab_dir}/getIntent.nix" || -f "${lab_dir}/getCompilerInput.nix" ]] || missing "${lab_dir}/getIntent.nix or getCompilerInput.nix"
[[ -f "${lab_dir}/getInventory.nix" ]] || missing "${lab_dir}/getInventory.nix"
[[ -f "${lab_dir}/getInventorySops.nix" ]] || missing "${lab_dir}/getInventorySops.nix"
[[ -f "${lab_dir}/getResolvedInventory.nix" ]] || missing "${lab_dir}/getResolvedInventory.nix"

if [[ "${status}" -ne 0 ]]; then
  report_missing
  exit "${status}"
fi

for renderer in nixos clab; do
  nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
  let
    resolved = import ${lab_dir}/getResolvedInventory.nix { renderer = \"${renderer}\"; };
    values = builtins.toJSON resolved;
    has = needle: builtins.match \".*\${needle}.*\" values != null;
    hostilePrefix =
      resolved.controlPlane.sites.esp.clab.tenants.hostile.routedPrefixes.hostile-public or null;
    nodes = resolved.realization.nodes or { };
    hetzPolicyPorts = (nodes.esp-hetz-router-policy or { }).ports or { };
    hetzUpstreamPorts = (nodes.esp-hetz-router-upstream or { }).ports or { };
  in
    if has \"runtime-public-dns-\" then
      throw \"lab-sigma getResolvedInventory(${renderer}) still contains runtime-public-dns-* placeholders; resolve them through getInventorySops before compiler/rendering\"
    else if !(has \"1.1.1.1\" && has \"9.9.9.9\" && has \"2606:4700:4700::1111\" && has \"2620:fe::fe\") then
      throw \"lab-sigma getResolvedInventory(${renderer}) must inject public DNS forwarder addresses from getInventorySops\"
    else if hostilePrefix == null || hostilePrefix.sourceFile != \"/run/secrets/access-node-ipv6-prefix-esp-clab-router-access-hostile\" then
      throw \"lab-sigma getResolvedInventory(${renderer}) must realize the hostile runtime IPv6 routed prefix from getInventorySops\"
    else if !(hetzPolicyPorts ? upstream-dmz-east-west) || !(hetzUpstreamPorts ? policy-dmz-east-west) then
      throw \"lab-sigma getResolvedInventory(${renderer}) must realize Hetzner DMZ east-west policy/upstream ports for overlay DNS\"
    else
      true
" >/dev/null
done

echo "PASS lab-sigma-runtime-contract"
