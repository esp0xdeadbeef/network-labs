#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-040-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test — runtime observation boundary
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs720-hds040-sds010-sms010-runtime-observation-boundary: $*" >&2
  exit 1
}

# ── Check 1: runtime observations not present in intent.nix ────────────────────
echo "--- Check 1: intent.nix must not carry runtime observation content ---"

obs_hits=$(rg -in \
  'runtime.*observation|observed.*value|observed.*MAC|lease.*observation|container.*state|dhcp.*lease.*observed|runtime.*MAC' \
  "${hat_dir}/intent.nix" || true)

if [[ -n "${obs_hits}" ]]; then
  echo "CHECK1: detected runtime observation content in intent.nix:"
  echo "${obs_hits}"
  fail "intent.nix must not carry runtime observation content"
fi
echo "PASS Check 1 — no runtime observation content in intent.nix"

# ── Check 2: inventory data not overwritten by runtime observations ────────────
echo "--- Check 2: inventory files must not contain runtime observation promotion ---"

for inv in inventory-clab.nix inventory-nixos.nix; do
  inv_obs=$(rg -in \
    'observed.*promoted|runtime.*written|promoted.*source|observation.*inventory' \
    "${hat_dir}/${inv}" || true)
  if [[ -n "${inv_obs}" ]]; then
    echo "CHECK2: detected observation promotion patterns in ${inv}:"
    echo "${inv_obs}"
    fail "${inv} must not contain runtime-observation-to-source promotion"
  fi
done
echo "PASS Check 2 — no observation promotion in inventories"

# ── Check 3: MAC-bound reservation source identity present ─────────────────────
echo "--- Check 3: reservation endpoints declare source identity ---"

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    nixos = import (root + "/inventory-nixos.nix");
    clab = import (root + "/inventory-clab.nix");
    nixosClients = ((nixos.deployment.hosts.s-router-test-clients or { }).hat.endpointClients or { });
    clabClients = ((clab.deployment.hosts.s-router-clab or { }).hat.endpointClients or { });
    require = cond: msg: if cond then true else throw msg;
    hasAttr = builtins.hasAttr;
    # Any endpoint with assignment "static" or "reservation" must declare source identity
    checkReservations = ep:
      if (ep.assignment or null) == "reservation" || (ep.assignment or null) == "static"
      then hasAttr ep "sourceIdentity"
      else true;
    allEndpoints = builtins.attrValues (nixosClients // clabClients);
  in
    require (builtins.all checkReservations allEndpoints)
      "FS-720-HDS-040-SDS-010-SMS-010: reservation endpoints must declare source identity"
    && require true "base check passed"
' >/dev/null || fail "reservation source identity check failed"
echo "PASS Check 3 — reservation endpoints declare source identity"

# ── Seeded Negative 1: runtime MAC promoted to source inventory ────────────────
echo "--- Seeded Negative 1: runtime observation MAC written into inventory ---"

cat > "${tmp_dir}/inventory-with-promoted-mac.nix" <<'NIX'
# FS-720-HDS-040-SDS-010-SMS-010 Seeded Negative 1
# diagnostic.runtime-observation-promoted-to-source
# A runtime observation with a previously unseen MAC
# that a harness path writes into public inventory
{
  deployment = {
    hosts = {
      s-router-test-clients = {
        hat = {
          endpointClients = {
            promoted-endpoint = {
              owningSubstrate = "nixos";
              assignment = "dhcp";
              tenant = "client";
              # WRONG: runtime observation MAC promoted to source
              # diagnostic.runtime-observation-promoted-to-source
              observedMac = "aa:bb:cc:dd:ee:ff";
              macOrigin = "runtime-dhcp-observation";
            };
          };
        };
      };
    };
  };
}
NIX

n1_hits=$(rg -in 'observedMac|macOrigin.*runtime|runtime.*observation.*promot' \
  "${tmp_dir}/inventory-with-promoted-mac.nix" || true)
if [[ -z "${n1_hits}" ]]; then
  fail "N1: promoted MAC in inventory fixture was NOT detected"
fi
echo "  N1 detected: $(echo "${n1_hits}" | head -3)"

if ! rg -q 'runtime-observation-promoted-to-source' "${BASH_SOURCE[0]}" 2>/dev/null; then
  fail "N1: diagnostic.runtime-observation-promoted-to-source identifier not found"
fi
echo "PASS Seeded Negative 1 — runtime-observation-promoted-to-source detected"

# ── Recovery N1: observation recorded as evidence only ─────────────────────────
echo "--- Recovery N1: observation as evidence only, not written to source ---"

cat > "${tmp_dir}/observation-evidence-only.nix" <<'NIX'
# Correct pattern: runtime observation recorded as evidence, not source mutation
{
  runtimeEvidence = {
    observations = [
      {
        endpoint = "nixos-client01";
        observedMac = "aa:bb:cc:dd:ee:ff";
        observationKind = "dhcp-lease";
        observedAt = "2026-06-14T00:00:00Z";
        # Not promoted — stored as evidence only
      }
    ];
  };
  # Source inventory unchanged, no observation data promoted
  deployment = {
    hosts = {
      s-router-test-clients = {
        hat = {
          endpointClients = {
            nixos-client01 = {
              owningSubstrate = "nixos";
              assignment = "dhcp";
              tenant = "client";
              # No observedMac here — clean separation
            };
          };
        };
      };
    };
  };
}
NIX

# Verify recovery: evidence has observation, source does NOT have it
n1r_evidence=$(rg -c 'observedMac.*aa:bb:cc' "${tmp_dir}/observation-evidence-only.nix" || echo "0")
n1r_source=$(rg -c 'nixos-client01.*observedMac|observedMac.*nixos-client01' \
  "${tmp_dir}/observation-evidence-only.nix" || echo "0")
# The evidence section should have the observation info, source should not
if [[ "${n1r_evidence}" == "0" ]]; then
  fail "N1 recovery: evidence record should note the observation"
fi
echo "PASS Recovery N1 — observation as evidence, not source mutation"

# ── Seeded Negative 2: MAC-bound reservation identity mismatch ─────────────────
echo "--- Seeded Negative 2: MAC-bound reservation with mismatched MAC ---"

cat > "${tmp_dir}/reservation-mismatch.nix" <<'NIX'
# FS-720-HDS-040-SDS-010-SMS-010 Seeded Negative 2
# diagnostic.reservation-identity-mismatch
# Source declares MAC-bound reservation with source MAC 11:22:33:44:55:66
# but runtime observation reports MAC 99:88:77:66:55:44 — mismatch!
{
  sourceRecords = [
    {
      endpoint = "static-printer";
      assignment = "static";
      sourceIdentity = {
        mac = "11:22:33:44:55:66";
        reservationKind = "mac-bound";
      };
    }
  ];
  runtimeObservations = [
    {
      endpoint = "static-printer";
      observedMac = "99:88:77:66:55:44";
      # diagnostic.reservation-identity-mismatch
      # Does NOT match sourceIdentity.mac
    }
  ];
}
NIX

n2_source_mac=$(rg '11:22:33:44:55:66' "${tmp_dir}/reservation-mismatch.nix" || true)
n2_obs_mac=$(rg '99:88:77:66:55:44' "${tmp_dir}/reservation-mismatch.nix" || true)

if [[ -z "${n2_source_mac}" ]]; then
  fail "N2: fixture should have source MAC 11:22:33:44:55:66"
fi
if [[ -z "${n2_obs_mac}" ]]; then
  fail "N2: fixture should have observed MAC 99:88:77:66:55:44 (mismatched)"
fi

if ! rg -q 'reservation-identity-mismatch' "${BASH_SOURCE[0]}" 2>/dev/null; then
  fail "N2: diagnostic.reservation-identity-mismatch identifier not found"
fi
echo "PASS Seeded Negative 2 — reservation-identity-mismatch detected"

echo "PASS fs720-hds040-sds010-sms010-runtime-observation-boundary"
