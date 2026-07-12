#!/usr/bin/env bash
# GAMP-ID: FS-260-HDS-010-SDS-010-SMS-015
# GAMP-SCOPE: HAT probe — live CLAB runtime nft ruleset verification
# Construction Handoff: SMS line 73-78
# Validation Evidence Boundary: live-required (SMS line 7)
set -euo pipefail

CLAB_HOST="${CLAB_HOST:-s-router-clab}"
CLAB_USER="${CLAB_USER:-root}"
TRACE_ID="FS-260-HDS-010-SDS-010-SMS-015"
OVERALL_RESULT="PASS"
FAILURES=()

ssh_cmd() {
    ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new "${CLAB_USER}@${CLAB_HOST}" "$@"
}

fail() {
    local msg="$1"
    FAILURES+=("$msg")
    OVERALL_RESULT="FAIL"
    echo "FAIL: $msg" >&2
}

pass() {
    echo "PASS: $1"
}

docker_exec() {
    ssh_cmd "docker exec ${POLICY_CONTAINER} $*"
}

echo "=== HAT Policy nft Rules Probe ==="
echo "TRACE_ID: ${TRACE_ID}"
echo "CLAB_HOST: ${CLAB_HOST}"
echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# ── FC1: SSH to CLAB host ──────────────────────────────────────────────
echo "--- FC1: SSH connectivity ---"
if ssh_cmd "echo ok" 2>/dev/null | grep -q ok; then
    pass "SSH to ${CLAB_HOST} successful"
else
    fail "SSH to ${CLAB_HOST} failed (FC1)"
    echo "=== PROBE RESULT: FAIL ==="
    echo "Failure conditions:"
    for f in "${FAILURES[@]}"; do echo "  - $f"; done
    exit 1
fi

# ── FC2: Resolve policy container via Docker ───────────────────────────
echo "--- FC2: Policy container resolution ---"
POLICY_CONTAINER=$(ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new "${CLAB_USER}@${CLAB_HOST}" 'docker ps --filter "name=clab-fabric-.*-policy$" --format "{{.Names}}"' 2>/dev/null | head -1)
if [[ -z "${POLICY_CONTAINER}" ]]; then
    fail "No policy container matching clab-fabric-.*-policy\$ found (FC2)"
    echo "=== PROBE RESULT: FAIL ==="
    echo "Failure conditions:"
    for f in "${FAILURES[@]}"; do echo "  - $f"; done
    exit 1
fi
pass "Policy container resolved: ${POLICY_CONTAINER}"

# ── FC3: Execute nft list ruleset ──────────────────────────────────────
echo "--- FC3: nft list ruleset execution ---"
RULESET=$(docker_exec "nft list ruleset" 2>&1) || {
    fail "nft list ruleset failed inside ${POLICY_CONTAINER} (FC3)"
    echo "=== PROBE RESULT: FAIL ==="
    echo "nft output:"
    echo "${RULESET}"
    echo "Failure conditions:"
    for f in "${FAILURES[@]}"; do echo "  - $f"; done
    exit 1
}
pass "nft list ruleset captured successfully"
RULESET_FILE="/tmp/nft-ruleset-${TRACE_ID}-$(date +%s).txt"
docker_exec "nft list ruleset" > "${RULESET_FILE}" 2>/dev/null || true
echo "Ruleset saved to: ${RULESET_FILE}"

# ── FC4: Forward chain existence ──────────────────────────────────────
echo "--- FC4: Forward chain existence ---"
if echo "${RULESET}" | grep -q 'chain forward'; then
    pass "Forward chain exists in nft ruleset"
else
    fail "No forward chain in nft ruleset (FC4)"
fi

# ── FC5: Forward chain drop-default policy ─────────────────────────────
echo "--- FC5: Forward chain drop-default policy ---"
if echo "${RULESET}" | grep -A1 'chain forward' | grep -q 'policy drop'; then
    pass "Forward chain has drop-default policy"
else
    if echo "${RULESET}" | grep -A1 'chain forward' | grep -q 'policy accept'; then
        fail "Forward chain has accept-default policy instead of drop-default (FC5)"
    else
        fail "Forward chain policy not found or unrecognized (FC5)"
    fi
fi

# ── FC6: Forward rule count (zero = hard failure) ──────────────────────
echo "--- FC6: Forward rule count ---"
# Count actual rules (exclude the chain property line "type filter hook...")
FW_RULES_COUNT=$(echo "${RULESET}" | awk '/chain forward/{found=1; next} found && /^}/{exit} found && /^\t\t[^t}]/' | grep -cvE '^\s*$' || true)
if [[ "${FW_RULES_COUNT}" -gt 0 ]]; then
    pass "Forward chain has ${FW_RULES_COUNT} rules (non-zero)"
else
    fail "Forward chain has zero rules — hard failure (FC6)"
fi

# ── FC7/MR5: Extract fabric interface accept rules ─────────────────────
echo "--- FC7: Fabric interface accept rules ---"
# Extract iifname/oifname pairs from accept rules (any interface naming)
# Format: "if1|if2" using pipe separator (not -> which confuses cut with - in ->)
ACCEPT_PAIRS=$(echo "${RULESET}" | awk '/chain forward/{found=1; next} found && /^}/{exit} found && /accept/' | \
    grep -oP 'iifname\s+"([^"]+)"\s+oifname\s+"([^"]+)"' | \
    sed 's/iifname "\([^"]*\)" oifname "\([^"]*\)"/\1|\2/' || true)

if [[ -z "${ACCEPT_PAIRS}" ]]; then
    fail "Zero fabric accept rules found — no fabric traffic rules (FC7)"
else
    echo "Fabric accept pairs found:"
    echo "${ACCEPT_PAIRS}" | while read -r pair; do
        echo "  ${pair}"
    done
    ACCEPT_COUNT=$(echo "${ACCEPT_PAIRS}" | grep -c '.' || true)
    pass "Found ${ACCEPT_COUNT} fabric accept rule pair(s)"
fi

# ── MR6/MR7/FC10: Bidirectional symmetry check ─────────────────────────
echo "--- MR6/MR7/FC10: Bidirectional symmetry ---"
MISSING_REVERSE=()
while IFS= read -r pair; do
    [[ -z "${pair}" ]] && continue
    IF1="${pair%%|*}"
    IF2="${pair##*|}"
    REVERSE="${IF2}|${IF1}"
    if ! echo "${ACCEPT_PAIRS}" | grep -qF "${REVERSE}"; then
        MISSING_REVERSE+=("${IF1}->${IF2} (no reverse: ${IF2}->${IF1})")
    fi
done <<< "${ACCEPT_PAIRS}"

if [[ ${#MISSING_REVERSE[@]} -eq 0 ]]; then
    pass "All forward pairs have matching reverse rules — bidirectional symmetry confirmed"
else
    echo "Missing reverse pairs (D18-NEW return-path gaps):"
    for gap in "${MISSING_REVERSE[@]}"; do
        echo "  ${gap}"
    done
    fail "One or more forward pairs lack return-path reverse rules (FC10/D18-NEW)"
fi

# ── MR8: Cross-check CPM control-plane.json ────────────────────────────
echo "--- MR8: CPM control-plane.json cross-check ---"
CPM_JSON="/etc/network-artifacts/control-plane.json"
CPM_EXISTS=$(ssh_cmd "test -f ${CPM_JSON} && echo yes || echo no" 2>/dev/null)
if [[ "${CPM_EXISTS}" != "yes" ]]; then
    fail "CPM control-plane.json not found at ${CPM_JSON} on ${CLAB_HOST}"
else
    pass "CPM control-plane.json present on ${CLAB_HOST}"
    # Count firewallIntent presence using grep on the JSON
    FW_INTENT_COUNT=$(ssh_cmd "grep -c '\"firewallIntent\"' ${CPM_JSON} 2>/dev/null" 2>/dev/null || true)
    FW_INTENT_COUNT=$(echo "${FW_INTENT_COUNT}" | grep -oP '\d+' | head -1 || echo "0")
    [[ -z "${FW_INTENT_COUNT}" ]] && FW_INTENT_COUNT=0
    # Count allowedRelations using grep
    ALLOWED_REL_COUNT=$(ssh_cmd "grep -c '\"allowedRelations\"' ${CPM_JSON} 2>/dev/null" 2>/dev/null || true)
    ALLOWED_REL_COUNT=$(echo "${ALLOWED_REL_COUNT}" | grep -oP '\d+' | head -1 || echo "0")
    [[ -z "${ALLOWED_REL_COUNT}" ]] && ALLOWED_REL_COUNT=0

    echo "  firewallIntent occurrences: ${FW_INTENT_COUNT}"
    echo "  allowedRelations occurrences: ${ALLOWED_REL_COUNT}"

    # FC8: CPM has firewall rules but container has zero forward rules
    if [[ "${FW_INTENT_COUNT}" -gt 0 ]] && [[ "${FW_RULES_COUNT}" -eq 0 ]]; then
        fail "CPM has firewall rules but policy container has zero forward rules — renderer deployment failure (FC8)"
    fi

    # FC9: CPM has zero firewall rules AND container has zero forward rules
    if [[ "${FW_INTENT_COUNT}" -eq 0 ]] && [[ "${FW_RULES_COUNT}" -eq 0 ]]; then
        fail "CPM has zero firewall rules AND policy container has zero forward rules — CPM/NFM pipeline failure (FC9)"
    fi

    # CommunicationContract path analysis
    if [[ "${FW_INTENT_COUNT}" -eq 0 ]] && [[ "${ALLOWED_REL_COUNT}" -gt 0 ]]; then
        echo "  Pipeline classification: CPM uses communicationContract path (not firewallIntent). Pipeline functioning."
    fi
fi

echo ""
echo "=== PROBE RESULT: ${OVERALL_RESULT} ==="
echo "Failure conditions (${#FAILURES[@]}):"
if [[ ${#FAILURES[@]} -eq 0 ]]; then
    echo "  None triggered"
else
    for f in "${FAILURES[@]}"; do
        echo "  - ${f}"
    done
fi
echo "Captured ruleset: ${RULESET_FILE}"

# ── Seeded Negative Tests ──────────────────────────────────────────────
if [[ "${OVERALL_RESULT}" == "PASS" ]]; then
    echo ""
    echo "=== Seeded Negative Tests ==="

    # SN1: Missing reverse rule injection
    echo "--- SN1: Missing reverse rule injection ---"
    echo "Injecting ens99->ens98 forward accept with no reverse rule..."
    ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new "${CLAB_USER}@${CLAB_HOST}" \
        "docker exec ${POLICY_CONTAINER} nft add rule inet fw forward iifname ens99 oifname ens98 accept comment SN1-seeded-negative" 2>&1 || {
        fail "SN1: Failed to inject seeded negative rule"
    }
    # Re-extract pairs and check for gap
    SN1_RULESET=$(docker_exec "nft list ruleset" 2>&1)
    SN1_PAIRS=$(echo "${SN1_RULESET}" | awk '/chain forward/{found=1; next} found && /^}/{exit} found && /accept/' | \
        grep -oP 'iifname\s+"([^"]+)"\s+oifname\s+"([^"]+)"' | \
        sed 's/iifname "\([^"]*\)" oifname "\([^"]*\)"/\1|\2/' || true)

    SN1_GAP=""
    while IFS= read -r pair; do
        [[ -z "${pair}" ]] && continue
        IF1="${pair%%|*}"
        IF2="${pair##*|}"
        REVERSE="${IF2}|${IF1}"
        if ! echo "${SN1_PAIRS}" | grep -qF "${REVERSE}"; then
            SN1_GAP="${IF1}->${IF2} (no reverse: ${IF2}->${IF1})"
        fi
    done <<< "${SN1_PAIRS}"

    if [[ -n "${SN1_GAP}" ]] && echo "${SN1_GAP}" | grep -q "ens99->ens98"; then
        pass "SN1: Missing reverse rule gap correctly detected — ${SN1_GAP} (D18-NEW)"
    else
        fail "SN1: Expected missing reverse pair ens99->ens98 (no reverse: ens98->ens99) not detected. Gap found: ${SN1_GAP:-none}"
    fi

    # Clean up SN1 injection
    echo "Cleaning up SN1 injected rule..."
    HANDLE=$(docker_exec "nft -a list ruleset" 2>&1 | grep 'SN1-seeded-negative' | grep -oP 'handle \d+' | awk '{print $2}' | head -1)
    if [[ -n "${HANDLE}" ]]; then
        docker_exec "nft delete rule inet fw forward handle ${HANDLE}" 2>&1 || true
    fi
    echo "SN1 cleanup done."

    # SN2: Zero rules flush
    echo "--- SN2: Zero rules flush ---"
    echo "Flushing forward chain rules..."
    docker_exec "nft flush chain inet fw forward" 2>&1 || {
        fail "SN2: Failed to flush forward chain"
    }
    SN2_RULESET=$(docker_exec "nft list ruleset" 2>&1)
    # Count actual rules (exclude the chain property line "type filter hook...")
    SN2_RULES_COUNT=$(echo "${SN2_RULESET}" | awk '/chain forward/{found=1; next} found && /^}/{exit} found && /^\t\t[^t}]/' | grep -cvE '^\s*$' || true)
    SN2_ENS_COUNT=$(echo "${SN2_RULESET}" | awk '/chain forward/{found=1; next} found && /^}/{exit} found && /accept/' | grep -cE 'iifname|oifname' || true)

    if [[ "${SN2_RULES_COUNT}" -eq 0 ]]; then
        pass "SN2: FC6 triggered — zero forward rules after flush (count=${SN2_RULES_COUNT})"
    else
        fail "SN2: FC6 not triggered — expected 0 forward rules, got ${SN2_RULES_COUNT}"
    fi

    if [[ "${SN2_ENS_COUNT}" -eq 0 ]]; then
        pass "SN2: FC7 triggered — zero fabric accept rules after flush (count=${SN2_ENS_COUNT})"
    else
        fail "SN2: FC7 not triggered — expected 0 fabric accept rules, got ${SN2_ENS_COUNT}"
    fi

    echo ""
    echo "=== SEEDED NEGATIVE RESULTS ==="
    echo "SN1 (missing reverse rule): $([[ -n "${SN1_GAP}" ]] && echo "PASS" || echo "FAIL")"
    echo "SN2 (zero rules flush): $([[ "${SN2_RULES_COUNT}" -eq 0 && "${SN2_ENS_COUNT}" -eq 0 ]] && echo "PASS" || echo "FAIL")"
fi

echo ""
echo "=== FINAL RESULT ==="
if [[ ${#FAILURES[@]} -eq 0 ]]; then
    echo "HAT probe PASS — all SMS predicates verified on live CLAB runtime"
else
    echo "HAT probe FAIL — ${#FAILURES[@]} failure(s)"
    for f in "${FAILURES[@]}"; do
        echo "  - ${f}"
    done
fi

[[ "${OVERALL_RESULT}" == "PASS" ]] && exit 0 || exit 1
