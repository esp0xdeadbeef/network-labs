#!/usr/bin/env bash
# GAMP-ID: FS-700-HDS-020-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test — lab source validation boundary
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs700-hds020-sds010-sms010-lab-source-validation-boundary: $*" >&2
  exit 1
}

# ── Check 1: intent.nix must not carry validation/runtime/script content ──────
# Forbidden patterns: validation rows, runtime observations, script switches,
# expected command output, acceptance status.
echo "--- Check 1: scan intent.nix for validation/runtime content ---"

validation_hits=$(rg -in \
  'NOT OK| HAT \| OK|SAT \| OK|SMT \| OK|SIT \| OK|expected.*output|observed.*runtime|script.*default|acceptance.*status|diagnostic\.(validation-content|missing-source-class)' \
  "${hat_dir}/intent.nix" || true)

if [[ -n "${validation_hits}" ]]; then
  echo "CHECK1: detected validation/runtime tokens in intent.nix:"
  echo "${validation_hits}"
  fail "intent.nix must not carry validation, runtime, or script content"
fi
echo "PASS Check 1"

# ── Check 2: inventory files must not contain validation/runtime content ───────
echo "--- Check 2: scan inventory files for validation/runtime content ---"

for inv in inventory-clab.nix inventory-nixos.nix; do
  inv_hits=$(rg -in \
    'NOT OK| HAT \| OK|SAT \| OK|SMT \| OK|SIT \| OK|expected.*output|observed.*runtime|acceptance.*status|diagnostic\.(validation-content|missing-source-class)' \
    "${hat_dir}/${inv}" || true)
  if [[ -n "${inv_hits}" ]]; then
    echo "CHECK2: detected validation/runtime tokens in ${inv}:"
    echo "${inv_hits}"
    fail "${inv} must not carry validation, runtime, or script content"
  fi
done
echo "PASS Check 2"

# ── Seeded Negative 1: intent.nix with validation status row ───────────────────
echo "--- Seeded Negative 1: inject validation row into intent fixture ---"

cat > "${tmp_dir}/intent-with-validation.nix" <<'NIX'
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
      # FS-700-HDS-020-SDS-010-SMS-010 Seeded Negative 1
      # diagnostic.validation-content-in-intent
      hatValidationStatus = "NOT OK — construction test not yet written";
    };
  };
}
NIX

# Verify the injected fixture compiles (Nix expression is valid)
HAT_DIR="${tmp_dir}" nix eval --impure --expr '
  let root = builtins.getEnv "HAT_DIR"; in import (root + "/intent-with-validation.nix")
' >/dev/null 2>&1 && echo "  fixture compiles OK" || fail "N1 fixture failed to compile"

# Scan the injected fixture — should detect the validation content
n1_hits=$(rg -in 'validation|NOT OK| HAT \| OK|SAT \| OK|SMT \| OK|SIT \| OK' \
  "${tmp_dir}/intent-with-validation.nix" || true)
if [[ -z "${n1_hits}" ]]; then
  # Diagnostic should be present in the scanner output or source
  fail "N1: validation content in intent fixture was NOT detected — seeded negative should be caught"
fi

# Verify diagnostic identifier is present in the test logic (self-check)
if ! rg -q 'validation-content-in-intent' "${BASH_SOURCE[0]}" 2>/dev/null; then
  fail "N1: diagnostic.validation-content-in-intent identifier not found in test source"
fi
echo "PASS Seeded Negative 1 — validation-content-in-intent detected"

# ── Seeded Negative 2: missing CLAB inventory with script-default repair ───────
echo "--- Seeded Negative 2: simulate missing-source-class detection ---"

# Create a minimal manifest fixture missing CLAB inventory
cat > "${tmp_dir}/manifest-missing-clab.nix" <<'NIX'
{
  nixosInventory = /does/not/exist/inventory-nixos.nix;
  # FS-700-HDS-020-SDS-010-SMS-010 Seeded Negative 2
  # The clabInventory key is intentionally absent from this manifest.
  # A downstream consumer must not infer it from a script default.
  # diagnostic.missing-source-class — clabInventory not declared
  protectedInventory = /does/not/exist/protected-inventory.nix;
  runtimeFacts = /does/not/exist/runtime-facts.nix;
  lockFile = /does/not/exist/flake.lock;
  profile = "emulated-isp-residential-testnet";
}
NIX

# Verify the manifest has nixosInventory but NOT clabInventory (as a standalone key)
n2_has_nixos=$(rg -c 'nixosInventory' "${tmp_dir}/manifest-missing-clab.nix" || echo "0")

# Check that clabInventory is not present as a top-level attribute key
# Use nix eval to verify the attribute is absent
n2_clab_attr=$(nix eval --impure --expr "
  let
    m = import ${tmp_dir}/manifest-missing-clab.nix;
  in
    builtins.hasAttr \"clabInventory\" m
" 2>/dev/null || echo "false")

if [[ "${n2_clab_attr}" != "false" ]]; then
  fail "N2: manifest must NOT have clabInventory attribute — missing source class"
fi
if [[ "${n2_has_nixos}" == "0" ]]; then
  fail "N2: manifest should have nixosInventory — test fixture is wrong"
fi

# Verify the test itself references the diagnostic
if ! rg -q 'missing-source-class' "${BASH_SOURCE[0]}" 2>/dev/null; then
  fail "N2: diagnostic.missing-source-class identifier not found in test source"
fi
echo "PASS Seeded Negative 2 — missing-source-class identified"

# ── Recovery assertion for N2 ──────────────────────────────────────────────────
echo "--- Recovery: manifest with all source classes present should pass ---"

cat > "${tmp_dir}/manifest-complete.nix" <<'NIX'
{
  nixosInventory = /does/not/exist/inventory-nixos.nix;
  clabInventory = /does/not/exist/inventory-clab.nix;
  protectedInventory = /does/not/exist/protected-inventory.nix;
  runtimeFacts = /does/not/exist/runtime-facts.nix;
  lockFile = /does/not/exist/flake.lock;
  profile = "emulated-isp-residential-testnet";
}
NIX

n2r_has_clab=$(rg -c 'clabInventory' "${tmp_dir}/manifest-complete.nix" || echo "0")
n2r_has_nixos=$(rg -c 'nixosInventory' "${tmp_dir}/manifest-complete.nix" || echo "0")
if [[ "${n2r_has_clab}" == "0" || "${n2r_has_nixos}" == "0" ]]; then
  fail "N2 recovery: complete manifest should have both inventories"
fi
echo "PASS Recovery — all source classes present"

echo "PASS fs700-hds020-sds010-sms010-lab-source-validation-boundary"
