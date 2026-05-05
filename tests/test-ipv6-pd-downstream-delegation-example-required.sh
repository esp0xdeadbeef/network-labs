#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
example_dir="${repo_root}/examples/ipv6-pd-downstream-delegation"

for required in intent.nix inventory-clab.nix inventory-nixos.nix; do
  if [[ ! -f "${example_dir}/${required}" ]]; then
    echo "FATAL missing IPv6 PD downstream-delegation example file: ${example_dir}/${required}" >&2
    exit 1
  fi
done

EXAMPLE_DIR="${example_dir}" nix eval --impure --expr '
  let
    example = builtins.getEnv "EXAMPLE_DIR";
    intent = import (example + "/intent.nix");
    nixosInventory = import (example + "/inventory-nixos.nix");
    clabInventory = import (example + "/inventory-clab.nix");
    siteIntent = intent.esp0xdeadbeef.site-a;
    nixosSite = nixosInventory.controlPlane.sites.esp0xdeadbeef.site-a;
    clabSite = clabInventory.controlPlane.sites.esp0xdeadbeef.site-a;
    hasClientBPrefix =
      builtins.any
        (prefix: (prefix.name or null) == "client-b" && (prefix.ipv6 or null) == "2001:db8:30::/52")
        siteIntent.ownership.prefixes;
    inventoryOk = site:
      site.ipv6.pd.delegatedPrefixLength == 48
      && site.ipv6.pd.perTenantPrefixLength == 64
      && site.tenants.client.ipv6.mode == "dhcpv6"
      && site.tenants.client-b.ipv6.mode == "delegated"
      && site.tenants.client-b.ipv6.delegatedPrefixLength == 52;
  in
    hasClientBPrefix && inventoryOk nixosSite && inventoryOk clabSite
' >/dev/null || {
  cat >&2 <<'EOF'
FAIL IPv6 PD downstream-delegation example is malformed.

Expected:
  - provider-facing PD length /48
  - normal client receives /64 behavior
  - client-b is modeled as a downstream delegated-prefix receiver with /52
  - both NixOS and CLAB inventories carry the same control-plane facts
EOF
  exit 1
}

echo "PASS ipv6-pd-downstream-delegation-example-required"
