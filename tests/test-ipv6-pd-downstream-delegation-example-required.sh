#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
example_dir="${repo_root}/examples/ipv6-pd-downstream-delegation"
cpm_flake="${CPM_FLAKE:-github:esp0xdeadbeef/network-control-plane-model}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

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
    intentPdOk =
      siteIntent.ipv6.pd.delegatedPrefixLength == 48
      && siteIntent.ipv6.pd.perTenantPrefixLength == 64
      && siteIntent.ipv6.pd.uplink == "wan"
      && siteIntent.ipv6.tenants.client-a.mode == "dhcpv6"
      && siteIntent.ipv6.tenants.client-b.mode == "slaac"
      && siteIntent.ipv6.tenants.mgmt.mode == "static"
      && siteIntent.ipv6.tenants.mgmt.prefixes == [ "2001:db8:10::/64" ];
    hasClientBPrefix =
      builtins.any
        (prefix:
          (prefix.name or null) == "client-b"
          && (prefix.ipv6 or null) == "fd42:dead:beef:30::/64"
          && builtins.any
            (routed:
              (routed.name or null) == "client-b-downstream-public"
              && (routed.family or null) == "ipv6"
              && (routed.allocation or null) == "runtime"
              && (routed.delegatedPrefixLength or null) == 48
              && (routed.perTenantPrefixLength or null) == 52
              && (routed.sourceFile or null) == "/run/s88-ipv6-pd/wan.prefix")
            (prefix.routedPrefixes or [ ]))
        siteIntent.ownership.prefixes;
    inventoryOk = site:
      !(site ? ipv6)
      && !((site.tenants.client-b or { }) ? routedPrefixes);
  in
    intentPdOk && hasClientBPrefix && inventoryOk nixosSite && inventoryOk clabSite
' >/dev/null || {
  cat >&2 <<'EOF'
FAIL IPv6 PD downstream-delegation example is malformed.

Expected:
  - provider-facing PD length /48 in intent
  - client-a receives normal /64 behavior
  - client-b keeps an access-link /64 and owns a named runtime IPv6 routed
    prefix that delegates a /52 downstream
  - NixOS and CLAB inventories do not repeat IPv6 PD or routed-prefix semantics
EOF
  exit 1
}

compile_inventory() {
  local inventory_name="$1"
  local output_json="${tmp_dir}/${inventory_name}.json"
  local compile_log="${tmp_dir}/${inventory_name}.compile.log"

  nix run "${cpm_flake}#compile-and-build-control-plane-model" -- \
    "${example_dir}/intent.nix" \
    "${example_dir}/${inventory_name}" \
    "${output_json}" >"${compile_log}"

  OUTPUT_JSON="${output_json}" nix eval --impure --expr '
    let
      data = builtins.fromJSON (builtins.readFile (builtins.getEnv "OUTPUT_JSON"));
      site = data.control_plane_model.data.esp0xdeadbeef."site-a";
      routed = builtins.head site.routedPrefixes."client-b";
    in
      (site.runtimeTargets ? "esp0xdeadbeef-site-a-s-router-access-client-b")
      && routed.name == "client-b-downstream-public"
      && routed.family == "ipv6"
      && routed.sourceFile == "/run/s88-ipv6-pd/wan.prefix"
      && routed.delegatedPrefixLength == 48
      && routed.perTenantPrefixLength == 52
  ' >/dev/null || {
    cat >&2 <<EOF
FAIL IPv6 PD downstream-delegation compile output is malformed for ${inventory_name}.

Expected CPM output to include:
  - runtime target esp0xdeadbeef-site-a-s-router-access-client-b
  - routedPrefixes.client-b[0] named client-b-downstream-public
  - runtime IPv6 source /48 -> /52 delegation metadata
EOF
    cat "${compile_log}" >&2
    exit 1
  }
}

compile_inventory inventory-nixos.nix
compile_inventory inventory-clab.nix

echo "PASS ipv6-pd-downstream-delegation-example-required"
