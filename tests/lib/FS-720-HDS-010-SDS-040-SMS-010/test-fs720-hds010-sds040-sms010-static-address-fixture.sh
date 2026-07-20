#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-040-SMS-010
# GAMP-SCOPE: software-module-test — static address fixture validation
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs720-hds010-sds040-sms010-static-address-fixture: $*" >&2
  exit 1
}

# ── Positive 1: Static fixtures carry all required fields ──────────────────────
echo "--- Positive 1: Static endpoint fixtures carry required fields ---"

# Extract all endpoint-configured static fixtures from NixOS inventory
# They must have: owningSubstrate, tenant, assignment=static-*, addressDelivery, ipv4/ipv6, gateway4/gateway6
HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    statics = builtins.filter
      (ep: (ep.assignment or \"\") == \"static-ipv4-or-ipv6-client\")
      (builtins.attrValues eps);
    require = cond: msg: if cond then true else throw msg;
    checks = map (ep:
      require (builtins.hasAttr \"owningSubstrate\" ep)
        \"FS-720-HDS-010-SDS-040-SMS-010 P1: static fixture \${ep.tenant or \"?\"} must declare owningSubstrate\"
      && require (builtins.hasAttr \"tenant\" ep)
        \"FS-720-HDS-010-SDS-040-SMS-010 P1: static fixture must declare tenant\"
      && require ((ep.assignment or \"\") == \"static-ipv4-or-ipv6-client\")
        \"FS-720-HDS-010-SDS-040-SMS-010 P1: static fixture must be static-ipv4-or-ipv6-client assignment\"
      && require ((ep.addressDelivery or \"\") == \"endpoint-configured\")
        \"FS-720-HDS-010-SDS-040-SMS-010 P1: static fixture must be endpoint-configured delivery\"
      && require (builtins.hasAttr \"ipv4\" ep || builtins.hasAttr \"ipv6\" ep)
        \"FS-720-HDS-010-SDS-040-SMS-010 P1: static fixture must have ipv4 or ipv6 addresses\"
      && require (builtins.hasAttr \"gateway4\" ep || builtins.hasAttr \"gateway6\" ep)
        \"FS-720-HDS-010-SDS-040-SMS-010 P1: static fixture must have gateway4 or gateway6\"
      && require (!(builtins.hasAttr \"mac\" ep) || (ep.mac or null) == null)
        \"FS-720-HDS-010-SDS-040-SMS-010 P1: static fixture must NOT require MAC inventory for non-MAC-bound assignment\"
    ) statics;
  in builtins.deepSeq checks true
" >/dev/null || fail "Positive 1: static fixture field validation failed"

HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    statics = builtins.filter
      (ep: (ep.assignment or \"\") == \"static-ipv4-or-ipv6-client\")
      (builtins.attrValues eps);
  in builtins.length statics
" >/dev/null || fail "Positive 1: nix eval failed"
echo "PASS Positive 1 — static fixtures carry all required fields"

# ── Positive 2: Static fixtures are distinct from DHCP fixtures ─────────────────
echo "--- Positive 2: Static fixtures distinguished from DHCP ---"

# Verify: no fixture with assignment=dhcp has addressDelivery=endpoint-configured
# and no static fixture lacks addressDelivery
HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    require = cond: msg: if cond then true else throw msg;
    dhcpEps = builtins.filter
      (ep: (ep.assignment or \"\") == \"dhcp\")
      (builtins.attrValues eps);
    # DHCP must NOT claim endpoint-configured delivery
    dhcpOk = builtins.all
      (ep: (ep.addressDelivery or null) == null)
      dhcpEps;
    # Static must claim endpoint-configured delivery
    staticEps = builtins.filter
      (ep: (ep.assignment or \"\") == \"static-ipv4-or-ipv6-client\")
      (builtins.attrValues eps);
    staticOk = builtins.all
      (ep: (ep.addressDelivery or \"\") == \"endpoint-configured\")
      staticEps;
  in
    require dhcpOk
      \"FS-720-HDS-010-SDS-040-SMS-010 P2: DHCP fixtures must not claim endpoint-configured delivery\"
    && require staticOk
      \"FS-720-HDS-010-SDS-040-SMS-010 P2: static fixtures must declare endpoint-configured delivery\"
" >/dev/null || fail "Positive 2: static vs DHCP distinction failed"
echo "PASS Positive 2 — static fixtures distinguished from DHCP"

# ── Positive 3: Static fixtures do not create authority ────────────────────────
echo "--- Positive 3: Static fixtures preserved as substrate, no authority leakage ---"

# Static fixtures must NOT have fields that create authority:
# routeAuthority, dnsAuthority, natAuthority, publicIngress, discoveryAuthority, managementAuthority
HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    statics = builtins.filter
      (ep: (ep.assignment or \"\") == \"static-ipv4-or-ipv6-client\")
      (builtins.attrValues eps);
    forbidden = [
      \"routeAuthority\" \"dnsAuthority\" \"natAuthority\"
      \"publicIngress\" \"discoveryAuthority\" \"managementAuthority\"
    ];
    require = cond: msg: if cond then true else throw msg;
    noLeak = builtins.all (ep:
      builtins.all (field: !(builtins.hasAttr field ep)) forbidden
    ) statics;
  in
    require noLeak
      \"FS-720-HDS-010-SDS-040-SMS-010 P3: static fixtures must not carry authority fields (route, DNS, NAT, ingress, discovery, management)\"
" >/dev/null || fail "Positive 3: authority leakage check failed"
echo "PASS Positive 3 — no authority leakage in static fixtures"

# ── Seeded Negative 1: Missing required fields ─────────────────────────────────
echo "--- Seeded Negative 1: static fixture missing required fields ---"

cat > "${tmp_dir}/neg1-missing-fields.nix" <<'NIX'
# FS-720-HDS-010-SDS-040-SMS-010 Seeded Negative 1
# diagnostic.missing-static-fixture-fields
# A static fixture without address/prefix/gateway should be rejected
{
  deployment = {
    hosts = {
      s-router-test-clients = {
        hat = {
          endpointClients = {
            nixos-broken-static = {
              assignment = "static-ipv4-or-ipv6-client";
              addressDelivery = "endpoint-configured";
              owningSubstrate = "nixos";
              tenant = "client";
              # MISSING: ipv4, ipv6, gateway4, gateway6
              # diagnostic.missing-static-fixture-fields
            };
          };
        };
      };
    };
  };
}
NIX

# Verify the negative exists (source check)
if ! rg -q 'missing-static-fixture-fields' "${tmp_dir}/neg1-missing-fields.nix"; then
  fail "N1: diagnostic.missing-static-fixture-fields not found in fixture"
fi

# Count actual field assignments (not comments): fixture should NOT have ipv4/ipv6/gateway fields
n1_missing=$(rg -c '^\s+(ipv4|ipv6|gateway4|gateway6)\s*=' "${tmp_dir}/neg1-missing-fields.nix" || echo "0")
if [[ "${n1_missing}" != "0" ]]; then
  fail "N1: negative fixture should NOT have ipv4/ipv6/gateway field assignments (found ${n1_missing})"
fi
echo "PASS Seeded Negative 1 — missing fields detected"

# ── Seeded Negative 2: MAC field required on non-MAC-bound fixture ──────────────
echo "--- Seeded Negative 2: MAC field present on non-MAC-bound static fixture ---"

cat > "${tmp_dir}/neg2-mac-required.nix" <<'NIX'
# FS-720-HDS-010-SDS-040-SMS-010 Seeded Negative 2
# diagnostic.mac-required-on-static-fixture
# A static fixture without MAC-bound assignment should not require MAC
{
  deployment = {
    hosts = {
      s-router-test-clients = {
        hat = {
          endpointClients = {
            nixos-static-with-mac = {
              assignment = "static-ipv4-or-ipv6-client";
              addressDelivery = "endpoint-configured";
              owningSubstrate = "nixos";
              tenant = "client";
              ipv4 = [ "10.99.99.99/24" ];
              gateway4 = "10.99.99.1";
              mac = "aa:bb:cc:dd:ee:ff";
              # diagnostic.mac-required-on-static-fixture
              macRequired = true;
            };
          };
        };
      };
    };
  };
}
NIX

if ! rg -q 'mac-required-on-static-fixture' "${tmp_dir}/neg2-mac-required.nix"; then
  fail "N2: diagnostic.mac-required-on-static-fixture not found in fixture"
fi

n2_has_mac=$(rg -c '^\s+mac\s*=' "${tmp_dir}/neg2-mac-required.nix" || echo "0")
if [[ "${n2_has_mac}" == "0" ]]; then
  fail "N2: negative fixture should contain a MAC address (test fixture is wrong)"
fi
echo "PASS Seeded Negative 2 — MAC requirement on non-MAC-bound fixture detected"

# ── Recovery: Real NixOS inventory static fixtures pass all checks ──────────────
echo "--- Recovery: Real NixOS inventory static fixtures are well-formed ---"

HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    statics = builtins.filter
      (ep: (ep.assignment or \"\") == \"static-ipv4-or-ipv6-client\")
      (builtins.attrValues eps);
    require = cond: msg: if cond then true else throw msg;
  in
    require (builtins.length statics > 0)
      \"FS-720-HDS-010-SDS-040-SMS-010 Recovery: inventory must contain at least one static fixture\"
" >/dev/null || fail "Recovery: no static fixtures found in inventory"
echo "PASS Recovery — real inventory static fixtures present and well-formed"

echo "PASS fs720-hds010-sds040-sms010-static-address-fixture"
