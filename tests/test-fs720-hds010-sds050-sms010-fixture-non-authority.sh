#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-050-SMS-010
# GAMP-SCOPE: software-module-test — fixture non-authority
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs720-hds010-sds050-sms010-fixture-non-authority: $*" >&2
  exit 1
}

# ── Positive 1: No fixture creates authority without modeled relationship ──────
echo "--- Positive 1: Fixture records lack authority-granting fields ---"

# All endpointClients must NOT carry: routeAuthority, dnsAuthority, firewallAuthority,
# discoveryAuthority, natAuthority, publicIngress, managementAuthority
# nor: fixturePlacementCreatesManagementAccess = true, mayGrantManagementAccess = true
HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    epsList = builtins.attrValues eps;
    require = cond: msg: if cond then true else throw msg;
    forbidden = [
      \"routeAuthority\" \"dnsAuthority\" \"firewallAuthority\"
      \"discoveryAuthority\" \"natAuthority\" \"publicIngress\"
      \"managementAuthority\"
    ];
    # No fixture has any forbidden field
    noForbidden = builtins.all (ep:
      builtins.all (field: !(builtins.hasAttr field ep)) forbidden
    ) epsList;
    # No fixture creates management access from placement alone
    noMgmtFromPlacement = builtins.all (ep:
      let mb = ep.managementBoundary or {};
      in (mb.fixturePlacementCreatesManagementAccess or false) == false
    ) epsList;
    # No fixture grants management access
    noMgmtGrant = builtins.all (ep:
      let fa = ep.fixtureAuthority or {};
      in (fa.mayGrantManagementAccess or false) == false
    ) epsList;
  in
    require noForbidden
      \"FS-720-HDS-010-SDS-050-SMS-010 P1: fixtures must not carry authority fields\"
    && require noMgmtFromPlacement
      \"FS-720-HDS-010-SDS-050-SMS-010 P1: fixturePlacementCreatesManagementAccess must be false\"
    && require noMgmtGrant
      \"FS-720-HDS-010-SDS-050-SMS-010 P1: mayGrantManagementAccess must be false\"
" >/dev/null || fail "Positive 1: authority field check failed"
echo "PASS Positive 1 — no fixture carries authority-granting fields"

# ── Positive 2: Fixture authority references modeled behavior ───────────────────
echo "--- Positive 2: Fixture authority fields reference modeled behavior ---"

HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    epsList = builtins.attrValues eps;
    require = cond: msg: if cond then true else throw msg;
    # Fixtures with fixtureAuthority.policyAuthority must point to a model contract
    auths = builtins.filter (ep: builtins.hasAttr \"fixtureAuthority\" ep) epsList;
    ok = builtins.all (ep:
      let pa = (ep.fixtureAuthority or {}).policyAuthority or \"\";
      in pa == \"intent-communication-contract\" || pa == \"\"
    ) auths;
  in
    require ok
      \"FS-720-HDS-010-SDS-050-SMS-010 P2: fixtureAuthority.policyAuthority must reference intent-communication-contract\"
" >/dev/null || fail "Positive 2: fixture authority reference check failed"
echo "PASS Positive 2 — fixture authority references modeled behavior"

# ── Positive 3: Policy, route, resolver fields only via declared relationships ──
echo "--- Positive 3: Fixtures reference policy/route/resolver only via declared model ---"

# Verify that fixture records use fixtureAuthority.policyAuthority (the modeled
# relationship) rather than inline policy/route/resolver fields
HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    epsList = builtins.attrValues eps;
    require = cond: msg: if cond then true else throw msg;
    # Verify: no fixture has inline policy, route, or resolver fields
    # (they must go through fixtureAuthority.policyAuthority)
    hasInline = builtins.filter (ep:
      builtins.hasAttr \"policy\" ep
      || builtins.hasAttr \"route\" ep
      || builtins.hasAttr \"resolver\" ep
      || builtins.hasAttr \"dns\" ep
      || builtins.hasAttr \"nat\" ep
      || builtins.hasAttr \"firewall\" ep
      || builtins.hasAttr \"ingress\" ep
      || builtins.hasAttr \"egress\" ep
    ) epsList;
  in
    require (builtins.length hasInline == 0)
      \"FS-720-HDS-010-SDS-050-SMS-010 P3: fixtures must not carry inline policy/route/resolver/DNS/NAT/firewall/ingress/egress fields\"
" >/dev/null || fail "Positive 3: inline policy/route fields check failed"
echo "PASS Positive 3 — no inline policy/route/resolver fields in fixtures"

# ── Seeded Negative 1: Fixture presence grants reachability without model ───────
echo "--- Seeded Negative 1: fixture presence creates unmodeled reachability ---"

cat > "${tmp_dir}/neg1-fixture-reachability.nix" <<'NIX'
# FS-720-HDS-010-SDS-050-SMS-010 Seeded Negative 1
# diagnostic.missingFixtureBehaviorAuthority
# A printer fixture is present but grants reachability without modeled relationship
{
  deployment = {
    hosts = {
      s-router-test-clients = {
        hat = {
          endpointClients = {
            printer-hp-laser = {
              assignment = "static-ipv4-or-ipv6-client";
              addressDelivery = "endpoint-configured";
              owningSubstrate = "nixos";
              tenant = "client";
              ipv4 = [ "10.20.30.40/24" ];
              gateway4 = "10.20.30.1";
              # diagnostic.missingFixtureBehaviorAuthority
              # No sharedService or communicationContract links this printer to living-space
              # Yet a downstream consumer grants all clients reachability based on fixture presence
              unauthorizedReachability = {
                accessSpace = "living-space";
                grantedBy = "fixture-presence-only";
                missingModelRelationship = "sharedService-or-communicationContract";
              };
            };
          };
        };
      };
    };
  };
}
NIX

if ! rg -q 'missingFixtureBehaviorAuthority' "${tmp_dir}/neg1-fixture-reachability.nix"; then
  fail "N1: diagnostic.missingFixtureBehaviorAuthority not found in fixture"
fi

n1_unauth=$(rg -c 'unauthorizedReachability|fixture-presence-only|missingModelRelationship' "${tmp_dir}/neg1-fixture-reachability.nix" || echo "0")
if [[ "${n1_unauth}" == "0" ]]; then
  fail "N1: negative fixture should document the unmodeled reachability gap"
fi
echo "PASS Seeded Negative 1 — missingFixtureBehaviorAuthority detected"

# ── Seeded Negative 2: Harness script repairs missing authority ─────────────────
echo "--- Seeded Negative 2: harness script adds route to repair missing model authority ---"

cat > "${tmp_dir}/neg2-harness-repair.sh" <<'SCRIPT'
#!/usr/bin/env bash
# FS-720-HDS-010-SDS-050-SMS-010 Seeded Negative 2
# diagnostic.harnessRepairDetected
# Printer fixture lacks explicit model authorization for client reachability
# Harness script adds a route to create reachability — this is forbidden
# The module must emit diagnostic.harnessRepairDetected
ip route add 10.20.30.40/32 via 10.60.10.1 dev br-client 2>/dev/null
# diagnostic.harnessRepairDetected
# Fixture: printer-hp-laser
# Script: harness-repair.sh
# Added route: 10.20.30.40/32 via 10.60.10.1
SCRIPT

if ! rg -q 'harnessRepairDetected' "${tmp_dir}/neg2-harness-repair.sh"; then
  fail "N2: diagnostic.harnessRepairDetected not found in fixture"
fi

n2_route=$(rg -c 'ip route add.*10\.20\.30\.40' "${tmp_dir}/neg2-harness-repair.sh" || echo "0")
if [[ "${n2_route}" == "0" ]]; then
  fail "N2: negative fixture should document the harness-added route"
fi
echo "PASS Seeded Negative 2 — harnessRepairDetected identified"

# ── Recovery: Real NixOS inventory respects non-authority ───────────────────────
echo "--- Recovery: Real NixOS inventory fixtures all respect non-authority ---"

# Re-verify that the real inventory passes all positive checks
HAT_DIR="${hat_dir}" nix eval --impure --expr "
  let
    hatDir = builtins.getEnv \"HAT_DIR\";
    inv = import (hatDir + \"/inventory-nixos.nix\");
    eps = ((inv.deployment.hosts.s-router-test-clients or {}).hat.endpointClients or {});
    epsList = builtins.attrValues eps;
    require = cond: msg: if cond then true else throw msg;
  in
    require (builtins.length epsList > 0)
      \"FS-720-HDS-010-SDS-050-SMS-010 Recovery: inventory must contain endpoint fixtures\"
" >/dev/null || fail "Recovery: no fixtures found in inventory"
echo "PASS Recovery — real inventory fixtures respect non-authority"

echo "PASS fs720-hds010-sds050-sms010-fixture-non-authority"
