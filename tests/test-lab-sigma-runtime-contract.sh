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
  in
    if has \"runtime-public-dns-\" then
      throw \"lab-sigma getResolvedInventory(${renderer}) still contains runtime-public-dns-* placeholders; resolve them through getInventorySops before compiler/rendering\"
    else if !(has \"1.1.1.1\" && has \"9.9.9.9\" && has \"2606:4700:4700::1111\" && has \"2620:fe::fe\") then
      throw \"lab-sigma getResolvedInventory(${renderer}) must inject public DNS forwarder addresses from getInventorySops\"
    else if hostilePrefix == null || hostilePrefix.sourceFile != \"/run/secrets/access-node-ipv6-prefix-esp-clab-router-access-hostile\" then
      throw \"lab-sigma getResolvedInventory(${renderer}) must realize the hostile runtime IPv6 routed prefix from getInventorySops\"
    else
      true
" >/dev/null
done

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
  let
    inventory = import ${lab_dir}/inventory.nix;
    nodes = inventory.realization.nodes;
    site = import ${lab_dir}/intent.nix;
    nixosRelations = site.esp.nixos.communicationContract.relations;
    hasRelation =
      builtins.any
        (relation:
          (relation.id or null) == \"allow-site-dns-service-to-uplinks\"
          && (relation.from.kind or null) == \"service\"
          && (relation.from.name or null) == \"site-dns-mgmt\")
        nixosRelations;
    normalDnsForwarders =
      builtins.map
        (name: nodes.\"esp-nixos-router-access-\${name}\".services.dns.forwarders or [ ])
        [ \"admin\" \"client\" \"dmz\" \"streaming\" ];
    allNormalUseSiteDns =
      builtins.all
        (forwarders: forwarders == [ \"10.20.10.1\" \"fd42:dead:beef:10::1\" ])
        normalDnsForwarders;
    policyPorts = nodes.esp-nixos-router-policy.ports;
    upstreamPorts = nodes.esp-nixos-router-upstream.ports;
    hasMgmtWanPorts =
      (policyPorts.upstream-mgmt-isp-a.link or null) == \"p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-a\"
      && (policyPorts.upstream-mgmt-isp-b.link or null) == \"p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-b\"
      && (upstreamPorts.policy-mgmt-isp-a.link or null) == \"p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-a\"
      && (upstreamPorts.policy-mgmt-isp-b.link or null) == \"p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-b\";
  in
    if !hasRelation then
      throw \"s-router-test nixos intent must allow the modeled site-dns-mgmt service to reach WAN DNS forwarders before tenant DNS-to-uplink denies\"
    else if !allNormalUseSiteDns then
      throw \"normal s-router-test nixos access DNS forwarders must point at modeled site-dns-mgmt, not public resolvers; only the service provider should egress to public DNS\"
    else if !hasMgmtWanPorts then
      throw \"s-router-test nixos inventory must explicitly realize site-dns-mgmt policy/upstream WAN lanes for isp-a and isp-b\"
    else
      true
" >/dev/null

echo "PASS lab-sigma-runtime-contract"
