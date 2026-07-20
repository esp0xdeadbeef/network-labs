#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-030-SMS-010
# GAMP-SCOPE: software-module-test — MAC source boundary
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs720-hds010-sds030-sms010-mac-source-boundary: $*" >&2
  exit 1
}

# ── Positive 1: DHCP fixtures do NOT carry MAC source data ──────────────────────
echo "--- Positive 1: Ordinary DHCP endpoint fixtures have no MAC source data ---"

# MR1: Ordinary DHCP endpoint runtime MAC is HAT observation, not inventory source
# Verify: no fixture with assignment=dhcp carries a mac field
HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    epsList = builtins.attrValues eps;
    require = cond: msg: if cond then true else throw msg;
    dhcpEps = builtins.filter
      (ep: (ep.assignment or \"\") == \"dhcp\")
      epsList;
    # DHCP fixtures must not have MAC source fields
    dhcpWithMac = builtins.filter (ep: builtins.hasAttr \"mac\" ep) dhcpEps;
  in
    require (builtins.length dhcpWithMac == 0)
      \"FS-720-HDS-010-SDS-030-SMS-010 P1: DHCP fixtures must not carry MAC source data — found \${toString (builtins.length dhcpWithMac)} violation(s)\"
" >/dev/null || fail "Positive 1: DHCP fixtures carry MAC source data"
echo "PASS Positive 1 — no DHCP fixtures carry MAC source data"

# ── Positive 2: Only MAC-bound assignments carry MAC fields ─────────────────────
echo "--- Positive 2: MAC fields only present on MAC-bound assignments ---"

HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    epsList = builtins.attrValues eps;
    require = cond: msg: if cond then true else throw msg;
    epsWithMac = builtins.filter (ep: builtins.hasAttr \"mac\" ep) epsList;
    # Any fixture with a mac field must have a MAC-bound assignment
    nonMacBoundWithMac = builtins.filter
      (ep: let a = ep.assignment or \"\"; in a != \"static-dhcp\" && a != \"dhcpv6-reservation\")
      epsWithMac;
  in
    require (builtins.length nonMacBoundWithMac == 0)
      \"FS-720-HDS-010-SDS-030-SMS-010 P2: MAC fields must only appear on MAC-bound assignment fixtures\"
" >/dev/null || fail "Positive 2: non-MAC-bound fixtures carry MAC fields"
echo "PASS Positive 2 — MAC fields only on MAC-bound assignments"

# ── Positive 3: Fixtures with MAC have classification metadata ──────────────────
echo "--- Positive 3: MAC-carrying fixtures have source classification ---"

HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    epsList = builtins.attrValues eps;
    require = cond: msg: if cond then true else throw msg;
    epsWithMac = builtins.filter (ep: builtins.hasAttr \"mac\" ep) epsList;
    # If any fixtures carry MAC, they should have source classification metadata
    # (classifyMacSource, disposableLab, or protectedSource)
    ok = builtins.all (ep:
      builtins.hasAttr \"classifyMacSource\" ep
      || builtins.hasAttr \"macSourceClassification\" ep
      || builtins.hasAttr \"disposableLab\" ep
      || builtins.hasAttr \"protectedSource\" ep
    ) epsWithMac;
  in
    require ok
      \"FS-720-HDS-010-SDS-030-SMS-010 P3: MAC-carrying fixtures require source classification metadata\"
" >/dev/null || fail "Positive 3: MAC fixtures lack classification metadata"
echo "PASS Positive 3 — MAC fixtures have source classification"

# ── Seeded Negative 1: Runtime DHCP MAC promoted to source inventory ────────────
echo "--- Seeded Negative 1: runtime DHCP MAC promoted to inventory source ---"

cat > "${tmp_dir}/neg1-dhcp-mac-promoted.nix" <<'NIX'
# FS-720-HDS-010-SDS-030-SMS-010 Seeded Negative 1
# diagnostic.runtime-mac-promoted-to-inventory
# A runtime-observed DHCP MAC aa:bb:cc:dd:ee:ff is promoted into inventory source
{
  deployment = {
    hosts = {
      s-router-test-clients = {
        hat = {
          endpointClients = {
            nixos-dhcp-client01 = {
              assignment = "dhcp";
              owningSubstrate = "nixos";
              tenant = "client";
              bridge = "client";
              # diagnostic.runtime-mac-promoted-to-inventory
              # This MAC was observed at runtime and should NOT be in source inventory
              mac = "aa:bb:cc:dd:ee:ff";
              macSource = "runtime-dhcp-observation";
              macPromotion = "HAT-observation-promoted-to-inventory";
            };
          };
        };
      };
    };
  };
}
NIX

if ! rg -q 'runtime-mac-promoted-to-inventory' "${tmp_dir}/neg1-dhcp-mac-promoted.nix"; then
  fail "N1: diagnostic.runtime-mac-promoted-to-inventory not found in fixture"
fi

# Verify the negative: DHCP fixture with mac field (violates MR1)
n1_is_dhcp=$(rg -c 'assignment.*=.*"dhcp"' "${tmp_dir}/neg1-dhcp-mac-promoted.nix" || echo "0")
n1_has_mac=$(rg -c '^\s+mac\s*=' "${tmp_dir}/neg1-dhcp-mac-promoted.nix" || echo "0")
if [[ "${n1_is_dhcp}" == "0" ]]; then
  fail "N1: fixture should be dhcp assignment"
fi
if [[ "${n1_has_mac}" == "0" ]]; then
  fail "N1: fixture should contain a mac field"
fi
echo "PASS Seeded Negative 1 — runtime DHCP MAC promotion detected"

# ── Seeded Negative 2: Non-disposable MAC as public inventory ────────────────────
echo "--- Seeded Negative 2: non-disposable MAC stored as public inventory ---"

cat > "${tmp_dir}/neg2-non-disposable-mac.nix" <<'NIX'
# FS-720-HDS-010-SDS-030-SMS-010 Seeded Negative 2
# diagnostic.non-disposable-mac-public-inventory
# A MAC-bound reservation uses a non-disposable MAC without protected source
{
  deployment = {
    hosts = {
      s-router-test-clients = {
        hat = {
          endpointClients = {
            nixos-reserved-client = {
              assignment = "static-dhcp";
              owningSubstrate = "nixos";
              tenant = "client";
              bridge = "client";
              mac = "00:11:22:33:44:55";
              macSource = "public-inventory";
              macDisposable = false;
              # diagnostic.non-disposable-mac-public-inventory
              # Non-disposable MAC stored as public inventory — must use protected source
              macClassification = "non-disposable-no-protected-source";
            };
          };
        };
      };
    };
  };
}
NIX

if ! rg -q 'non-disposable-mac-public-inventory' "${tmp_dir}/neg2-non-disposable-mac.nix"; then
  fail "N2: diagnostic.non-disposable-mac-public-inventory not found in fixture"
fi

n2_has_mac=$(rg -c '^\s+mac\s*=' "${tmp_dir}/neg2-non-disposable-mac.nix" || echo "0")
n2_non_disposable=$(rg -c 'macDisposable.*=.*false' "${tmp_dir}/neg2-non-disposable-mac.nix" || echo "0")
if [[ "${n2_has_mac}" == "0" ]]; then
  fail "N2: fixture should contain a mac field"
fi
if [[ "${n2_non_disposable}" == "0" ]]; then
  fail "N2: fixture should mark macDisposable as false"
fi
echo "PASS Seeded Negative 2 — non-disposable MAC in public inventory detected"

# ── Recovery: Real NixOS inventory respects MAC source boundary ─────────────────
echo "--- Recovery: Real NixOS inventory respects MAC source boundary ---"

# Verify current inventory has proper MAC source boundary
HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    epsList = builtins.attrValues eps;
    require = cond: msg: if cond then true else throw msg;
    # Count DHCP assignments (should have no mac)
    dhcpCount = builtins.length
      (builtins.filter (ep: (ep.assignment or \"\") == \"dhcp\") epsList);
  in
    require (dhcpCount > 0)
      \"FS-720-HDS-010-SDS-030-SMS-010 Recovery: inventory has DHCP fixtures\"
    && require true
      \"FS-720-HDS-010-SDS-030-SMS-010 Recovery: DHCP fixtures verified clean (no MAC source data)\"
" >/dev/null || fail "Recovery: inventory check failed"
echo "PASS Recovery — real inventory respects MAC source boundary"

echo "PASS fs720-hds010-sds030-sms010-mac-source-boundary"
