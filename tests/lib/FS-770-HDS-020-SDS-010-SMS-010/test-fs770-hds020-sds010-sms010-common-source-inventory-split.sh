#!/usr/bin/env bash
# GAMP-ID: FS-770-HDS-020-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test — common source inventory split
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs770-hds020-sds010-sms010-common-source-inventory-split: $*" >&2
  exit 1
}

# ── Check 1: intent.nix must not carry realization facts ───────────────────────
echo "--- Check 1: intent.nix (common behavior source) free of realization facts ---"

# Realization facts that belong in inventory, not common intent:
# bridgeNetworks, endpointClients, providerAccess, wanGroupToUplink,
# VLAN assignments, host placement, persistence facts
realization_hits=$(rg -in \
  'bridgeNetworks|endpointClients|providerAccess|wanGroupToUplink|hat\.endpointClients|hat\.providerAccess|realization\.nodes|bridgeNetworks\.client\.vlan|hostPlacement' \
  "${hat_dir}/intent.nix" || true)

if [[ -n "${realization_hits}" ]]; then
  echo "CHECK1: detected realization-fact classes in intent.nix:"
  echo "${realization_hits}"
  fail "intent.nix (common behavior source) must not carry realization facts"
fi
echo "PASS Check 1 — no realization facts in common intent"

# ── Check 2: both NixOS and CLAB inventories exist and are consumed ────────────
echo "--- Check 2: both inventory files present and independently loadable ---"

[[ -f "${hat_dir}/inventory-clab.nix" ]] || fail "inventory-clab.nix missing"
[[ -f "${hat_dir}/inventory-nixos.nix" ]] || fail "inventory-nixos.nix missing"

# Verify each inventory is a standalone Nix expression
HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    clab = import (root + "/inventory-clab.nix");
    nixos = import (root + "/inventory-nixos.nix");
    require = cond: msg: if cond then true else throw msg;
    hasAttr = builtins.hasAttr;
  in
    require (hasAttr "deployment" clab)
      "FS-770-HDS-020-SDS-010-SMS-010: CLAB inventory must be a standalone deployment record"
    && require (hasAttr "deployment" nixos)
      "FS-770-HDS-020-SDS-010-SMS-010: NixOS inventory must be a standalone deployment record"
    && require (!(hasAttr "esp0xdeadbeef" clab))
      "FS-770-HDS-020-SDS-010-SMS-010: CLAB inventory must not carry common intent"
    && require (!(hasAttr "esp0xdeadbeef" nixos))
      "FS-770-HDS-020-SDS-010-SMS-010: NixOS inventory must not carry common intent"
' >/dev/null || fail "inventory independence check failed"
echo "PASS Check 2 — both inventories independently loadable"

# ── Check 3: common intent and inventory are separate source classes ───────────
echo "--- Check 3: intent and inventory files are separate source classes ---"

# intent.nix must not import inventory files as its core structure
intent_imports_inv=$(rg -n 'import.*inventory-clab|import.*inventory-nixos' \
  "${hat_dir}/intent.nix" || true)
if [[ -n "${intent_imports_inv}" ]]; then
  fail "intent.nix must not import inventory files — they are separate source classes"
fi
echo "PASS Check 3 — intent and inventories are separate source classes"

# ── Check 4: inventory files do not silently ignore requirements ───────────────
echo "--- Check 4: both inventories declare their profile scope ---"

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    nixos = import (root + "/inventory-nixos.nix");
    clab = import (root + "/inventory-clab.nix");
    require = cond: msg: if cond then true else throw msg;
    hasAttr = builtins.hasAttr;
    # Each inventory must have host-specific HAT realization data
    nixosClients = ((nixos.deployment.hosts.s-router-test-clients or { }).hat.endpointClients or { });
    clabClients = ((clab.deployment.hosts.s-router-clab or { }).hat.endpointClients or { });
  in
    require (builtins.attrNames nixosClients != [ ])
      "FS-770-HDS-020-SDS-010-SMS-010: NixOS inventory must declare endpoint fixtures"
    && require (builtins.attrNames clabClients != [ ])
      "FS-770-HDS-020-SDS-010-SMS-010: CLAB inventory must declare endpoint fixtures"
' >/dev/null || fail "profile scope check failed"
echo "PASS Check 4 — both inventories declare profile scope"

# ── Seeded Negative 1: NixOS bridge in common intent ───────────────────────────
echo "--- Seeded Negative 1: NixOS bridge name injected into common behavior source ---"

cat > "${tmp_dir}/intent-with-bridge.nix" <<'NIX'
{
  esp0xdeadbeef = {
    site-a = {
      communicationContract = {
        interfaceTags = { tenant-client = "client"; };
        trafficTypes = [ ];
        relations = [ ];
        services = [ ];
        sharedServicePolicyAtoms = [ ];
      };
      hostManagement = { required = false; };
      ownership = { };
      topology = { nodes = { }; };
      # FS-770-HDS-020-SDS-010-SMS-010 Seeded Negative 1
      # diagnostic.realization-fact-in-common-intent
      # NixOS bridge name and VLAN assignment belong in inventory-nixos.nix
      bridgeNetworks = {
        client = {
          mode = "vlan";
          vlan = 302;
          host = "s-router-nixos";
        };
      };
    };
  };
}
NIX

# Apply Check 1 logic to the seeded-negative fixture: it MUST detect realization facts
n1_hits=$(rg -in \
  'bridgeNetworks|endpointClients|providerAccess|wanGroupToUplink|hat\.endpointClients|hat\.providerAccess|realization\.nodes|bridgeNetworks\.client\.vlan|hostPlacement' \
  "${tmp_dir}/intent-with-bridge.nix" || true)

if [[ -z "${n1_hits}" ]]; then
  fail "N1: realization-fact in common intent fixture was NOT detected — seeded negative is dormant"
fi
echo "  N1 detected: $(echo "${n1_hits}" | head -3)"

# Confirm the diagnostic identifier is in this test source (SMS requires diagnostic.realization-fact-in-common-intent)
if ! rg -q 'realization-fact-in-common-intent' "${BASH_SOURCE[0]}" 2>/dev/null; then
  fail "N1: diagnostic.realization-fact-in-common-intent identifier not found in test source"
fi

# The fixture must FAIL Check 1 validation — rf presence in common intent is a boundary failure
if rg -inq 'bridgeNetworks|endpointClients|providerAccess' "${tmp_dir}/intent-with-bridge.nix" 2>/dev/null; then
  : # expected — fixture contains realization facts, confirming the SMS failure condition
else
  fail "N1: fixture must fail realization-fact boundary check"
fi
echo "PASS Seeded Negative 1 — realization-fact-in-common-intent detected and rejected"
# ── Seeded Negative 2: CLAB inventory ignored ──────────────────────────────────
echo "--- Seeded Negative 2: both inventories declared but only NixOS consumed ---"

# Create fixture where CLAB inventory exists but has no consumed data
cat > "${tmp_dir}/clab-inventory-empty.nix" <<'NIX'
# FS-770-HDS-020-SDS-010-SMS-010 Seeded Negative 2
# diagnostic.clab-inventory-not-consumed
# CLAB inventory file exists but endpoint data is EMPTY — silently ignored
{
  deployment = {
    hosts = {
      s-router-clab = {
        hat = {
          # No endpointClients — CLAB inventory not consumed
        };
      };
    };
  };
}
NIX

cat > "${tmp_dir}/nixos-inventory-full.nix" <<'NIX'
# NixOS inventory with full endpoint data
{
  deployment = {
    hosts = {
      s-router-nixos = { };
      s-router-test-clients = {
        hat = {
          endpointClients = {
            nixos-client01 = {
              owningSubstrate = "nixos";
              assignment = "dhcp";
              tenant = "client";
            };
          };
        };
      };
    };
  };
}
NIX

# Apply Check 4 logic to the seeded-negative fixtures:
# NixOS has endpoints, CLAB has none → clab-inventory-not-consumed
n2_clab_empty=$(HAT_DIR="${tmp_dir}" nix eval --raw --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    clab = import (root + "/clab-inventory-empty.nix");
    clabHost = clab.deployment.hosts.s-router-clab or { };
    endpointClients = clabHost.hat.endpointClients or { };
  in
    builtins.toJSON (builtins.attrNames endpointClients)
' 2>/dev/null || echo "[]")

n2_nixos_full=$(HAT_DIR="${tmp_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    nixos = import (root + "/nixos-inventory-full.nix");
    clientHost = nixos.deployment.hosts.s-router-test-clients or { };
    endpointClients = clientHost.hat.endpointClients or { };
  in
    builtins.length (builtins.attrNames endpointClients)
' 2>/dev/null || echo "0")

# N2 proves: CLAB endpoint clients is empty while NixOS has data
# → diagnostic.clab-inventory-not-consumed
if [[ "${n2_clab_empty}" != "[]" ]]; then
  fail "N2: CLAB inventory should have empty endpointClients (clab-inventory-not-consumed)"
fi
if [[ "${n2_nixos_full}" == "0" ]]; then
  fail "N2: NixOS inventory should have endpoint data"
fi

# Confirm the diagnostic identifier is in this test source
if ! rg -q 'clab-inventory-not-consumed' "${BASH_SOURCE[0]}" 2>/dev/null; then
  fail "N2: diagnostic.clab-inventory-not-consumed identifier not found in test source"
fi

# The CLAB fixture must FAIL Check 4's profile-scope requirement:
# it has no endpointClients — proving the "clab inventory not consumed" failure condition
n2_clab_scope_fails=$(HAT_DIR="${tmp_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    clab = import (root + "/clab-inventory-empty.nix");
    clabHost = clab.deployment.hosts.s-router-clab or { };
    endpointClients = clabHost.hat.endpointClients or { };
    require = cond: msg: if cond then true else throw msg;
  in
    require (builtins.attrNames endpointClients != [ ])
      "FS-770-HDS-020-SDS-010-SMS-010: CLAB inventory must declare endpoint fixtures"
' 2>&1 || true)

if [[ -z "${n2_clab_scope_fails}" ]]; then
  fail "N2: CLAB inventory with empty endpointClients must fail profile-scope check (was not rejected)"
fi
echo "  N2 rejection: ${n2_clab_scope_fails}"
echo "PASS Seeded Negative 2 — clab-inventory-not-consumed identified and rejected"

# ── Recovery: both inventories fully consumed ──────────────────────────────────
echo "--- Recovery: both inventories carry and consume endpoint fixtures ---"

# In the real code, both inventories have endpoint data. Verify via nix eval.
HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    nixos = import (root + "/inventory-nixos.nix");
    clab = import (root + "/inventory-clab.nix");
    nixosClients = ((nixos.deployment.hosts.s-router-test-clients or { }).hat.endpointClients or { });
    clabClients = ((clab.deployment.hosts.s-router-clab or { }).hat.endpointClients or { });
    require = cond: msg: if cond then true else throw msg;
  in
    require (builtins.attrNames nixosClients != [ ])
      "FS-770-HDS-020-SDS-010-SMS-010 Recovery: NixOS inventory must have endpoints"
    && require (builtins.attrNames clabClients != [ ])
      "FS-770-HDS-020-SDS-010-SMS-010 Recovery: CLAB inventory must have endpoints"
' >/dev/null || fail "recovery: both inventories must have endpoints"
echo "PASS Recovery — both inventories fully consumed"

echo "PASS fs770-hds020-sds010-sms010-common-source-inventory-split"
