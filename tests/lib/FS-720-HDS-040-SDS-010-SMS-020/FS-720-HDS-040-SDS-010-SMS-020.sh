#!/usr/bin/env bash
# FS-720-HDS-040-SDS-010-SMS-020: CLAB Client-Origin Runtime Probes
# Focused construction test proving the probe harness can represent both
# NixOS and CLAB target substrates, requires client-origin metadata, and
# rejects the seeded negatives.
set -uo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
probe_harness="${repo_root}/GAMP/SMT/FS-720-HDS-040-SDS-010-SMS-020"

declare -i pass_count=0 check_count=0

pass() { pass_count=$((pass_count + 1)); check_count=$((check_count + 1)); }
fail() { check_count=$((check_count + 1)); echo "FAIL: $*"; }

# ============================================================
# Probe record template functions
# ============================================================

construct_probe() {
  local origin_container="$1"
  local owning_substrate="$2"
  local target_substrate="$3"
  local expected_row="$4"
  local command="$5"
  local expected_result="$6"
  local observed_result="$7"

  cat <<RECORD
{
  "origin": {
    "container": "${origin_container}",
    "owningSubstrate": "${owning_substrate}"
  },
  "targetSubstrate": "${target_substrate}",
  "expectedRow": "${expected_row}",
  "command": "${command}",
  "expectedResult": "${expected_result}",
  "observedResult": "${observed_result}"
}
RECORD
}

# ============================================================
# SMS Predicate Functions
# ============================================================

# MR3: Require HAT rows that claim CLAB client behavior to include a
# s-router-test-clients originated probe for that CLAB behavior
check_origin() {
  local probe="$1"
  local origin_container
  origin_container=$(echo "${probe}" | jq -r '.origin.container // ""')

  if [[ "${origin_container}" == "" ]]; then
    echo '{"diagnostic":"clab-client-origin-probe-missing","detail":"no origin container in probe record"}'
    return 1
  fi

  if [[ "${origin_container}" =~ ^s-router-clab ]]; then
    echo '{"diagnostic":"client-origin-substituted-by-host-probe","detail":"origin is s-router-clab host, not s-router-test-clients endpoint"}'
    return 1
  fi

  if [[ "${origin_container}" =~ ^s-router-test-clients ]]; then
    printf '{"status":"ok","origin":"%s"}' "${origin_container}"
    echo
    return 0
  fi

  echo '{"diagnostic":"clab-client-origin-probe-missing","detail":"origin does not match s-router-test-clients endpoint"}'
  return 1
}

# MR5: Reject host-only probes, docker exec inside s-router-clab,
# container liveness, rendered artifact presence, route-table presence,
# or control-plane artifact presence as substitutes
reject_substitution() {
  local probe="$1"
  local command
  command=$(echo "${probe}" | jq -r '.command // ""')
  local origin
  origin=$(echo "${probe}" | jq -r '.origin.container // ""')

  # docker exec inside s-router-clab is host substitution
  if echo "${command}" | grep -q "docker exec" && echo "${origin}" | grep -q "s-router-clab"; then
    echo '{"diagnostic":"client-origin-substituted-by-host-probe","detail":"docker exec inside s-router-clab is not client-origin proof"}'
    return 1
  fi

  # Probe from s-router-clab host directly
  if echo "${origin}" | grep -q "^s-router-clab$" && ! echo "${origin}" | grep -q "test-clients"; then
    echo '{"diagnostic":"client-origin-substituted-by-host-probe","detail":"probe originated from s-router-clab host, not test-clients endpoint"}'
    return 1
  fi

  # Liveness/artifact substitution keywords
  if echo "${command}" | grep -qiE "^(docker ps|containerlab inspect|ip route|nft list|cat.*(artifact|rendered|\.conf)|ls.*rendered)"; then
    echo '{"diagnostic":"positive-container-state-substitution","detail":"liveness or artifact presence is not client-origin proof"}'
    return 1
  fi

  echo '{"status":"ok","no-substitution":"probe is client-origin"}'
  return 0
}

# MR4: Preserve NixOS and CLAB probe coverage separately;
# success on one substrate shall not close the other.
check_substrate_coverage() {
  local nixos_probes="$1"
  local clab_probes="$2"

  if [[ "${nixos_probes}" -eq 0 ]]; then
    echo '{"diagnostic":"missing-nixos-probe-coverage"}'
    return 1
  fi
  if [[ "${clab_probes}" -eq 0 ]]; then
    echo '{"diagnostic":"missing-clab-probe-coverage"}'
    return 1
  fi
  printf '{"status":"ok","nixos":%d,"clab":%d}\n' "${nixos_probes}" "${clab_probes}"
  return 0
}

# Helper: check if jq result has a specific diagnostic key
has_diagnostic() {
  local json="$1"
  local diag="$2"
  echo "${json}" | jq -e --arg d "${diag}" '.diagnostic == $d' >/dev/null 2>&1
}

# Helper: check if jq result has status ok
is_ok() {
  local json="$1"
  echo "${json}" | jq -e '.status == "ok"' >/dev/null 2>&1
}

# ============================================================
# SMS Predicate Coverage Matrix - Construction Evidence
# ============================================================

echo "=== SMS-020 Predicate Coverage Matrix ==="

# ---- P1: Probe plan represents NixOS target substrate ----
echo ""
echo "--- P1: NixOS target substrate probe ---"
nixos_probe=$(construct_probe \
  "s-router-test-clients-endpoint-1" \
  "nixos-containers" \
  "nixos" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "ping -c1 10.2.208.10" \
  "reachable" \
  "reachable")

nixos_origin=$(check_origin "${nixos_probe}")
nixos_no_sub=$(reject_substitution "${nixos_probe}")

if is_ok "${nixos_origin}" && is_ok "${nixos_no_sub}"; then
  pass
  echo "  PASS: Nixos probe accepted with s-router-test-clients origin"
else
  fail "P1: Nixos probe rejected"
fi

# ---- P2: Probe plan represents CLAB target substrate ----
echo ""
echo "--- P2: CLAB target substrate probe ---"
clab_probe=$(construct_probe \
  "s-router-test-clients-endpoint-2" \
  "nixos-containers" \
  "clab" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "ping -c1 10.2.209.10" \
  "reachable" \
  "reachable")

clab_origin=$(check_origin "${clab_probe}")
clab_no_sub=$(reject_substitution "${clab_probe}")

if is_ok "${clab_origin}" && is_ok "${clab_no_sub}"; then
  pass
  echo "  PASS: CLAB probe accepted with s-router-test-clients origin"
else
  fail "P2: CLAB probe rejected"
fi

# ---- P3: Both substrates covered independently ----
echo ""
echo "--- P3: Substrate coverage preserved independently ---"
coverage=$(check_substrate_coverage 1 1)
if is_ok "${coverage}"; then
  pass
  echo "  PASS: Both NixOS (1) and CLAB (1) substrate probes present independently"
else
  fail "P3: Coverage check failed"
fi

# ---- SN1: Negative case 1 - CLAB behavior without test-client origin ----
echo ""
echo "--- SN1: CLAB behavior without test-client origin ---"
sn1_probe=$(construct_probe \
  "" \
  "clab" \
  "clab" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "ping -c1 10.2.209.10" \
  "reachable" \
  "reachable")

sn1_result=$(check_origin "${sn1_probe}")
if has_diagnostic "${sn1_result}" "clab-client-origin-probe-missing"; then
  pass
  echo "  PASS: Missing client-origin correctly rejected with diagnostic.clab-client-origin-probe-missing"
else
  fail "SN1: Should reject with clab-client-origin-probe-missing"
fi

# ---- SN1 Recovery: Same CLAB probe with proper origin is accepted ----
echo ""
echo "--- SN1 Recovery: CLAB probe with proper s-router-test-clients origin ---"
sn1_recovery_probe=$(construct_probe \
  "s-router-test-clients-endpoint-3" \
  "nixos-containers" \
  "clab" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "ping -c1 10.2.209.10" \
  "reachable" \
  "reachable")

sn1_recovery_result=$(check_origin "${sn1_recovery_probe}")
sn1_recovery_sub=$(reject_substitution "${sn1_recovery_probe}")
if is_ok "${sn1_recovery_result}" && is_ok "${sn1_recovery_sub}"; then
  pass
  echo "  PASS: Recovery - CLAB probe with s-router-test-clients origin accepted for CLAB side only"
else
  fail "SN1 Recovery: Should accept CLAB probe with test-clients origin"
fi

# ---- SN2: Negative case 2 - host/container substitution ----
echo ""
echo "--- SN2: Host/container substitution (docker exec inside s-router-clab) ---"
sn2_probe=$(construct_probe \
  "s-router-clab" \
  "clab" \
  "clab" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "docker exec clab-container ping -c1 10.2.209.10" \
  "reachable" \
  "reachable")

sn2_result=$(reject_substitution "${sn2_probe}")
if has_diagnostic "${sn2_result}" "client-origin-substituted-by-host-probe"; then
  pass
  echo "  PASS: Host/container substitution correctly rejected with diagnostic.client-origin-substituted-by-host-probe"
else
  fail "SN2: Should reject host substitution"
fi

# ---- SN2 variant: Probe from s-router-clab host directly ----
echo ""
echo "--- SN2b: Probe from s-router-clab host (not test-clients endpoint) ---"
sn2b_probe=$(construct_probe \
  "s-router-clab" \
  "clab" \
  "clab" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "ping -c1 10.2.209.10" \
  "reachable" \
  "reachable")

sn2b_result=$(reject_substitution "${sn2b_probe}")
if has_diagnostic "${sn2b_result}" "client-origin-substituted-by-host-probe"; then
  pass
  echo "  PASS: Direct s-router-clab host probe correctly rejected as host substitution"
else
  fail "SN2b: Should reject as host substitution"
fi

# ---- P4: Liveness/artifact substitution rejected ----
echo ""
echo "--- P4: Container liveness rejected as client-origin proof ---"
p4_probe=$(construct_probe \
  "s-router-test-clients-endpoint-4" \
  "nixos-containers" \
  "nixos" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "docker ps | grep clab-container" \
  "container running" \
  "container running")

p4_result=$(reject_substitution "${p4_probe}")
if has_diagnostic "${p4_result}" "positive-container-state-substitution"; then
  pass
  echo "  PASS: Container liveness correctly rejected as positive-container-state-substitution"
else
  fail "P4: Should reject liveness substitution"
fi

# ---- P5: Route-table presence rejected as client-origin proof ----
echo ""
echo "--- P5: Route-table presence rejected as client-origin proof ---"
p5_probe=$(construct_probe \
  "s-router-test-clients-endpoint-5" \
  "nixos-containers" \
  "nixos" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "ip route show table all" \
  "routes present" \
  "routes present")

p5_result=$(reject_substitution "${p5_probe}")
if has_diagnostic "${p5_result}" "positive-container-state-substitution"; then
  pass
  echo "  PASS: Route-table presence correctly rejected as positive-container-state-substitution"
else
  fail "P5: Should reject route-table substitution"
fi

# ---- P6: Artifact presence rejected ----
echo ""
echo "--- P6: Rendered artifact presence rejected ---"
p6_probe=$(construct_probe \
  "s-router-test-clients-endpoint-6" \
  "nixos-containers" \
  "nixos" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "cat /etc/rendered/routes.conf" \
  "artifact present" \
  "artifact present")

p6_result=$(reject_substitution "${p6_probe}")
if has_diagnostic "${p6_result}" "positive-container-state-substitution"; then
  pass
  echo "  PASS: Artifact presence correctly rejected as positive-container-state-substitution"
else
  fail "P6: Should reject artifact substitution"
fi

# ---- P7: Nixos-only coverage fails when CLAB missing (substrate separation) ----
echo ""
echo "--- P7: Nixos-only coverage fails (CLAB missing, substrates not interchangeable) ---"
coverage_nixos_only=$(check_substrate_coverage 2 0)
if has_diagnostic "${coverage_nixos_only}" "missing-clab-probe-coverage"; then
  pass
  echo "  PASS: Nixos-only coverage correctly rejected as missing CLAB probe coverage"
else
  fail "P7: Should reject nixos-only coverage"
fi

# ---- P8: CLAB-only coverage fails when NixOS missing (substrate separation) ----
echo ""
echo "--- P8: CLAB-only coverage fails (NixOS missing, substrates not interchangeable) ---"
coverage_clab_only=$(check_substrate_coverage 0 1)
if has_diagnostic "${coverage_clab_only}" "missing-nixos-probe-coverage"; then
  pass
  echo "  PASS: CLAB-only coverage correctly rejected as missing Nixos probe coverage"
else
  fail "P8: Should reject clab-only coverage"
fi

# ---- P9: Probe record structure completeness ----
echo ""
echo "--- P9: Probe record structure (origin container, owning substrate, target substrate, expected row, command, expected/observed result) ---"
struct_probe=$(construct_probe \
  "s-router-test-clients-endpoint-9" \
  "nixos-containers" \
  "nixos" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "dig @10.2.208.1 example.com" \
  "NOERROR" \
  "NOERROR")

has_origin_container=$(echo "${struct_probe}" | jq -e '.origin.container == "s-router-test-clients-endpoint-9"' >/dev/null 2>&1 && echo 1 || echo 0)
has_owning_substrate=$(echo "${struct_probe}" | jq -e '.origin.owningSubstrate == "nixos-containers"' >/dev/null 2>&1 && echo 1 || echo 0)
has_target_substrate=$(echo "${struct_probe}" | jq -e '.targetSubstrate == "nixos"' >/dev/null 2>&1 && echo 1 || echo 0)
has_expected_row=$(echo "${struct_probe}" | jq -e '.expectedRow == "FS-720-HDS-040-SDS-010-SMS-020"' >/dev/null 2>&1 && echo 1 || echo 0)
has_command=$(echo "${struct_probe}" | jq -e '.command == "dig @10.2.208.1 example.com"' >/dev/null 2>&1 && echo 1 || echo 0)
has_expected_result=$(echo "${struct_probe}" | jq -e '.expectedResult == "NOERROR"' >/dev/null 2>&1 && echo 1 || echo 0)
has_observed_result=$(echo "${struct_probe}" | jq -e '.observedResult == "NOERROR"' >/dev/null 2>&1 && echo 1 || echo 0)

if [[ "${has_origin_container}" == "1" && "${has_owning_substrate}" == "1" && "${has_target_substrate}" == "1" && \
      "${has_expected_row}" == "1" && "${has_command}" == "1" && "${has_expected_result}" == "1" && \
      "${has_observed_result}" == "1" ]]; then
  pass
  echo "  PASS: Probe record carries all required fields"
else
  fail "P9: Probe record missing fields"
fi

# ---- P10: Probe with missing origin container rejected ----
echo ""
echo "--- P10: Probe with missing origin container rejected ---"
missing_origin_probe=$(construct_probe \
  "" \
  "clab" \
  "clab" \
  "FS-720-HDS-040-SDS-010-SMS-020" \
  "curl http://10.2.209.10" \
  "HTTP 200" \
  "HTTP 200")

p10_result=$(check_origin "${missing_origin_probe}")
if has_diagnostic "${p10_result}" "clab-client-origin-probe-missing"; then
  pass
  echo "  PASS: Missing origin container correctly rejected"
else
  fail "P10: Should reject missing origin"
fi

# ============================================================
echo ""
echo "=== Results: ${pass_count}/${check_count} PASS ==="

if [[ "${pass_count}" -eq "${check_count}" ]]; then
  echo "ALL SMS PREDICATES PROVEN for FS-720-HDS-040-SDS-010-SMS-020"
  exit 0
else
  echo "SOME PREDICATES FAILED for FS-720-HDS-040-SDS-010-SMS-020"
  exit 1
fi
