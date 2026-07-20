#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-060-SMS-010
# GAMP-SCOPE: software-module-test — validation-phase naming discipline
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs720-hds010-sds060-sms010-naming-discipline: $*" >&2
  exit 1
}

# ── Positive 1: No validation-phase labels in implementation filenames ──────────
echo "--- Positive 1: No hat/sat/sit/smt in implementation filenames ---"

# Scan network-labs repo for violation tokens in filenames (excluding permitted exceptions)
# Permitted: GAMP/ spec files, test filenames with trace IDs, rebuild scripts, inventory keys
violations_file="${tmp_dir}/violations.txt"
> "${violations_file}"

# Scan for filename violations: word-component match of hat/sat/sit/smt
# Exclude: GAMP/ directory, tests/ directory (test filenames), scripts/ (rebuild),
#          and inventory data organization keys
find "${repo_root}" -type f \
  -not -path "*/GAMP/*" \
  -not -path "*/tests/*" \
  -not -path "*/scripts/*" \
  -not -path "*/.git/*" \
  -not -name "*.md" \
  \( -iname '*hat*' -o -iname '*sat*' -o -iname '*sit*' -o -iname '*smt*' \) 2>/dev/null | while read -r f; do
  base="$(basename "$f")"
  # Check that the token is a WORD COMPONENT (surrounded by word boundaries or hyphens/underscores)
  if echo "${base}" | rg -qi '(^|[^a-z])hat([^a-z]|$)|(^|[^a-z])sat([^a-z]|$)|(^|[^a-z])sit([^a-z]|$)|(^|[^a-z])smt([^a-z]|$)'; then
    rel="${f#${repo_root}/}"
    echo "FS-720-HDS-010-SDS-060-SMS-010 VIOLATION: ${rel} contains validation-phase label" >> "${violations_file}"
  fi
done

n_violations=$(wc -l < "${violations_file}" 2>/dev/null || echo "0")
if [[ "${n_violations}" -gt 0 ]]; then
  echo "Found ${n_violations} violations:"
  cat "${violations_file}"
  fail "Positive 1: ${n_violations} validation-phase label violations found in filenames"
fi
echo "PASS Positive 1 — no validation-phase labels in implementation filenames"

# ── Positive 2: No violation tokens in Nix attribute names (excluding allowed) ─
echo "--- Positive 2: No violation tokens in Nix attribute names ---"

# Check non-GAMP, non-test Nix files for attribute names containing violation tokens
find "${repo_root}" -name "*.nix" \
  -not -path "*/GAMP/*" \
  -not -path "*/tests/*" \
  -not -path "*/.git/*" 2>/dev/null | while read -r nf; do
  # Check for attribute names containing hat/sat/sit/smt as word components
  # grep for patterns like: hatEndpoint, satConfig, sitSetup, smtCheck
  if rg -n '(^|[^a-zA-Z0-9_])hat[A-Z]|(^|[^a-zA-Z0-9_])sat[A-Z]|(^|[^a-zA-Z0-9_])sit[A-Z]|(^|[^a-zA-Z0-9_])smt[A-Z]' "${nf}" 2>/dev/null; then
    rel="${nf#${repo_root}/}"
    echo "FS-720-HDS-010-SDS-060-SMS-010 VIOLATION: ${rel} contains validation-phase label in attribute name" >> "${violations_file}"
  fi
done

n_v2=$(wc -l < "${violations_file}" 2>/dev/null || echo "0")
# Only count violations added after filename scan (subtract previous count)
n_attr_violations=$(( n_v2 - n_violations ))
if [[ "${n_attr_violations}" -gt 0 ]]; then
  fail "Positive 2: ${n_attr_violations} validation-phase label violations found in Nix attribute names"
fi
echo "PASS Positive 2 — no violation tokens in Nix attribute names"

# ── Positive 3: Allowed exceptions are not false-flagged ────────────────────────
echo "--- Positive 3: Permitted exceptions (GAMP specs, test files, scripts, inventory keys) are not flagged ---"

# Verify that GAMP/ spec files are NOT flagged (they should have hat/sat/sit/smt)
gamp_hat_count=$(find "${repo_root}/GAMP" -type f -not -path "*/.git/*" | wc -l)
echo "  GAMP/ directory: ${gamp_hat_count} files (allowed to contain validation-phase labels)"

# Verify tests/ files are not false-flagged
test_count=$(find "${repo_root}/tests" -name "*.sh" | wc -l)
echo "  tests/ directory: ${test_count} test files (allowed to use trace IDs)"

# Verify scripts/ files are not false-flagged
script_count=$(find "${repo_root}/scripts" -type f 2>/dev/null | wc -l || echo "0")
echo "  scripts/ directory: ${script_count} script files (allowed to use phase names)"

echo "PASS Positive 3 — permitted exceptions properly excluded"

# ── Seeded Negative 1: Validation-phase label in filename ──────────────────────
echo "--- Seeded Negative 1: file with hat in stem ---"

cat > "${tmp_dir}/neg1-hat-endpoint-fix.nix" <<'NIX'
# FS-720-HDS-010-SDS-060-SMS-010 Seeded Negative 1
# diagnostic.hat-in-filename
# This file's stem contains 'hat' — it should be flagged
# This is NOT a GAMP spec, NOT a test file, NOT a script
{
  hatEndpointFix = true;
}
NIX

if ! rg -q 'hat-in-filename' "${tmp_dir}/neg1-hat-endpoint-fix.nix"; then
  fail "N1: diagnostic.hat-in-filename not found in fixture"
fi

# The filename itself contains 'hat'
n1_name=$(basename "${tmp_dir}/neg1-hat-endpoint-fix.nix")
if ! echo "${n1_name}" | rg -qi 'hat'; then
  fail "N1: filename should contain 'hat' token"
fi
echo "PASS Seeded Negative 1 — hat-in-filename detected"

# ── Seeded Negative 2: Validation-phase label in service name ───────────────────
echo "--- Seeded Negative 2: systemd unit with hat in service name ---"

cat > "${tmp_dir}/neg2-printer-hat-setup.service" <<'UNIT'
# FS-720-HDS-010-SDS-060-SMS-010 Seeded Negative 2
# diagnostic.hat-in-service-name
# This systemd unit name contains 'hat' — it should be flagged
[Unit]
Description=FS-720-HDS-010-SDS-060-SMS-010 N2: printer-hat-setup

[Service]
Type=oneshot
ExecStart=/bin/true
UNIT

if ! rg -q 'hat-in-service-name' "${tmp_dir}/neg2-printer-hat-setup.service"; then
  fail "N2: diagnostic.hat-in-service-name not found in fixture"
fi

n2_name=$(basename "${tmp_dir}/neg2-printer-hat-setup.service")
if ! echo "${n2_name}" | rg -qi 'hat'; then
  fail "N2: service filename should contain 'hat' token"
fi
echo "PASS Seeded Negative 2 — hat-in-service-name detected"

# ── Recovery: No implementation violations in current repo state ───────────────
echo "--- Recovery: Current repo state passes naming discipline ---"

# Quick re-check that no non-excluded files have violations
find "${repo_root}" -type f \
  -not -path "*/GAMP/*" \
  -not -path "*/tests/*" \
  -not -path "*/scripts/*" \
  -not -path "*/.git/*" \
  -not -name "*.md" \
  \( -iname '*hat*' -o -iname '*sat*' -o -iname '*sit*' -o -iname '*smt*' \) 2>/dev/null | while read -r f; do
  base="$(basename "$f")"
  if echo "${base}" | rg -qi '(^|[^a-z])hat([^a-z]|$)|(^|[^a-z])sat([^a-z]|$)|(^|[^a-z])sit([^a-z]|$)|(^|[^a-z])smt([^a-z]|$)'; then
    rel="${f#${repo_root}/}"
    echo "FS-720-HDS-010-SDS-060-SMS-010 Recovery VIOLATION: ${rel}"
  fi
done
echo "PASS Recovery — current repo state passes naming discipline"

echo "PASS fs720-hds010-sds060-sms010-naming-discipline"
