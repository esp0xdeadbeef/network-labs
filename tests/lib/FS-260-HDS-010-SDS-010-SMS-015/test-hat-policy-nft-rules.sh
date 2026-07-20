#!/usr/bin/env bash
# GAMP-ID: FS-260-HDS-010-SDS-010-SMS-015
# GAMP-SCOPE: HAT probe — live CLAB runtime nft ruleset verification
# Construction Handoff: SMS "Construction Handoff" / "CMC Implementation Gap"
# Validation Evidence Boundary: live-required (SMS header)
#
# Corrected predicate (2026-07-15 audit):
#   PASS requires forward authorization PLUS `ct state established,related`
#   return behavior (or equivalent target-native stateful return). Symmetric
#   blanket interface-pair accepts are NOT return-path proof. A
#   reverse-direction new-flow accept is valid only when a distinct modeled
#   reverse relation carries its own policy authority and enforceable match
#   scope; an interface-only reverse accept whose only basis is symmetry,
#   comment, relation label, topology adjacency, or trafficType="any" is
#   rejected as unsafe reverse authorization.
set -euo pipefail

CLAB_HOST="${CLAB_HOST:-s-router-clab}"
CLAB_USER="${CLAB_USER:-root}"
FABRIC_IF_REGEX="${FABRIC_IF_REGEX:-^ens}"
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

abort() {
    echo "=== PROBE RESULT: FAIL ==="
    echo "Failure conditions:"
    for f in "${FAILURES[@]}"; do echo "  - $f"; done
    exit 1
}

docker_exec() {
    ssh_cmd "docker exec ${POLICY_CONTAINER} $*"
}

echo "=== HAT Policy nft Rules Probe (stateful-return contract) ==="
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
    abort
fi

# ── FC2: Resolve policy container via Docker ───────────────────────────
echo "--- FC2: Policy container resolution ---"
POLICY_CONTAINER=$(ssh_cmd 'docker ps --filter "name=clab-fabric-.*-policy$" --format "{{.Names}}"' 2>/dev/null | head -1)
if [[ -z "${POLICY_CONTAINER}" ]]; then
    fail "No policy container matching clab-fabric-.*-policy\$ found (FC2)"
    abort
fi
pass "Policy container resolved: ${POLICY_CONTAINER}"

# ── FC3: Execute nft list ruleset ──────────────────────────────────────
echo "--- FC3: nft list ruleset execution ---"
RULESET=$(docker_exec "nft list ruleset" 2>&1) || {
    fail "nft list ruleset failed inside ${POLICY_CONTAINER} (FC3)"
    echo "nft output:"
    echo "${RULESET}"
    abort
}
pass "nft list ruleset captured successfully"
RULESET_FILE="/tmp/nft-ruleset-${TRACE_ID}-$(date +%s).txt"
printf '%s\n' "${RULESET}" > "${RULESET_FILE}"
echo "Ruleset saved to: ${RULESET_FILE}"

# ── ruleset helpers ─────────────────────────────────────────────────────
# Locate the table (family + name) that carries the forward chain.
forward_table() {
    printf '%s\n' "$1" | awk '
        /^table / { fam=$2; tbl=$3; sub(/ *\{.*$/, "", tbl) }
        /^\tchain forward \{/ { print fam " " tbl; exit }
    '
}

# Body of the forward chain: rule lines only (no "type filter hook" header).
forward_body() {
    printf '%s\n' "$1" | awk '
        /^\tchain forward \{/ { found=1; next }
        found && /^\t\}/ { exit }
        found {
            line=$0
            sub(/^\t\t/, "", line)
            if (line ~ /^type filter hook/) next
            if (line ~ /^[[:space:]]*$/) next
            print line
        }
    '
}

# New-flow accept rules: accept action, interface pair match, and not a
# connection-tracking stateful return rule.
new_flow_accepts() {
    printf '%s\n' "$1" | grep -E '(^| )accept( |$)' | grep -E 'iifname' | grep -E 'oifname' | grep -Ev 'ct state (established|related)' || true
}

pair_of() {
    printf '%s\n' "$1" | sed -n 's/.*iifname "\([^"]*\)".*oifname "\([^"]*\)".*/\1|\2/p'
}

comment_of() {
    printf '%s\n' "$1" | sed -n 's/.*comment "\([^"]*\)".*/\1/p'
}

# Match scope beyond interface names: strip iifname/oifname/counter/accept/
# comment tokens; anything left is enforceable match scope (proto, ports,
# addresses, ct state new, ...).
scope_of() {
    printf '%s\n' "$1" | sed \
        -e 's/iifname "[^"]*"//g' \
        -e 's/oifname "[^"]*"//g' \
        -e 's/counter packets [0-9]* bytes [0-9]*//g' \
        -e 's/\bcounter\b//g' \
        -e 's/comment "[^"]*"//g' \
        -e 's/\baccept\b//g' \
        -e 's/[[:space:]]\+/ /g' \
        -e 's/^ //; s/ $//'
}

# Global stateful return rule present in a chain body?
has_global_stateful_return() {
    printf '%s\n' "$1" | grep -E 'ct state established,related' | grep -E '(^| )accept( |$)' | grep -qvE 'iifname|oifname'
}

# Pair-scoped stateful return rule for reverse direction B->A present?
has_pair_stateful_return() {
    local body="$1" rev_in="$2" rev_out="$3"
    printf '%s\n' "${body}" | grep -E 'ct state established,related' | grep -E '(^| )accept( |$)' | \
        grep -F "iifname \"${rev_in}\"" | grep -qF "oifname \"${rev_out}\""
}

# Evaluate return-path coverage + reverse-authorization safety for a chain
# body. Populates EVAL_MISSING_STATEFUL and EVAL_UNSAFE_REVERSE arrays.
evaluate_return_contract() {
    local body="$1"
    local cpm_relations="${2:-}"
    EVAL_MISSING_STATEFUL=()
    EVAL_UNSAFE_REVERSE=()

    local accepts
    accepts="$(new_flow_accepts "${body}")"
    [[ -z "${accepts}" ]] && return 0

    local pairs=""
    while IFS= read -r rule; do
        [[ -z "${rule}" ]] && continue
        local pair
        pair="$(pair_of "${rule}")"
        [[ -z "${pair}" ]] && continue
        pairs+="${pair}"$'\n'
    done <<< "${accepts}"

    while IFS= read -r rule; do
        [[ -z "${rule}" ]] && continue
        local pair if_in if_out relid scope mirror
        pair="$(pair_of "${rule}")"
        [[ -z "${pair}" ]] && continue
        if_in="${pair%%|*}"
        if_out="${pair##*|}"
        relid="$(comment_of "${rule}")"
        scope="$(scope_of "${rule}")"
        mirror="${if_out}|${if_in}"

        # FC10 / D18-NEW: every forward allow needs stateful return coverage.
        if ! has_global_stateful_return "${body}" && \
           ! has_pair_stateful_return "${body}" "${if_out}" "${if_in}"; then
            EVAL_MISSING_STATEFUL+=("${if_in}->${if_out} relation=${relid:-<none>} lacks ct state established,related return coverage (D18-NEW)")
        fi

        # FC11: reverse-direction new-flow accept safety.
        if printf '%s\n' "${pairs}" | grep -qFx "${mirror}"; then
            if [[ -z "${scope}" ]]; then
                # Interface-only accept whose mirror also exists: the only
                # basis is symmetry/comment/label/adjacency/any — unsafe.
                EVAL_UNSAFE_REVERSE+=("${if_in}->${if_out} relation=${relid:-<none>} interface-only reverse new-flow accept (symmetry basis, no enforceable scope)")
            elif [[ -z "${relid}" ]]; then
                EVAL_UNSAFE_REVERSE+=("${if_in}->${if_out} scoped reverse new-flow accept carries no relation identity (no distinct modeled reverse relation)")
            elif [[ -n "${cpm_relations}" ]] && ! printf '%s\n' "${cpm_relations}" | grep -qF "${relid}"; then
                EVAL_UNSAFE_REVERSE+=("${if_in}->${if_out} relation=${relid} not present in CPM control-plane.json (no modeled reverse authority)")
            fi
        fi
    done <<< "${accepts}"
}

# ── FC4: Forward chain existence ───────────────────────────────────────
echo "--- FC4: Forward chain existence ---"
FW_TABLE="$(forward_table "${RULESET}")"
if [[ -n "${FW_TABLE}" ]]; then
    pass "Forward chain exists in nft ruleset (table: ${FW_TABLE})"
else
    fail "No forward chain in nft ruleset (FC4)"
    abort
fi
FW_FAMILY="${FW_TABLE%% *}"
FW_TABLE_NAME="${FW_TABLE##* }"

# ── FC5: Forward chain drop-default policy ─────────────────────────────
echo "--- FC5: Forward chain drop-default policy ---"
FW_HOOK_LINE=$(printf '%s\n' "${RULESET}" | awk '/^\tchain forward \{/{found=1; next} found{print; exit}')
if printf '%s\n' "${FW_HOOK_LINE}" | grep -q 'policy drop'; then
    pass "Forward chain has drop-default policy"
elif printf '%s\n' "${FW_HOOK_LINE}" | grep -q 'policy accept'; then
    fail "Forward chain has accept-default policy instead of drop-default (FC5)"
else
    fail "Forward chain policy not found or unrecognized (FC5)"
fi

# ── FC6: Forward rule count (zero = hard failure) ──────────────────────
echo "--- FC6: Forward rule count ---"
FW_BODY="$(forward_body "${RULESET}")"
FW_RULES_COUNT=$(printf '%s\n' "${FW_BODY}" | grep -c . || true)
if [[ "${FW_RULES_COUNT}" -gt 0 ]]; then
    pass "Forward chain has ${FW_RULES_COUNT} rules (non-zero)"
else
    fail "Forward chain has zero rules — hard failure (FC6)"
fi

# ── FC7 / MR5: Fabric interface accept rules ───────────────────────────
echo "--- FC7: Fabric interface accept rules ---"
ACCEPT_PAIRS=""
while IFS= read -r rule; do
    [[ -z "${rule}" ]] && continue
    p="$(pair_of "${rule}")"
    [[ -z "${p}" ]] && continue
    if printf '%s\n' "${p%%|*}" | grep -qE "${FABRIC_IF_REGEX}" || \
       printf '%s\n' "${p##*|}" | grep -qE "${FABRIC_IF_REGEX}"; then
        ACCEPT_PAIRS+="${p}"$'\n'
    fi
done <<< "$(new_flow_accepts "${FW_BODY}")"
ACCEPT_PAIRS="$(printf '%s' "${ACCEPT_PAIRS}")"

if [[ -z "${ACCEPT_PAIRS}" ]]; then
    fail "Zero fabric (${FABRIC_IF_REGEX}) forward accept rules found (FC7)"
else
    echo "Fabric new-flow accept pairs:"
    printf '%s\n' "${ACCEPT_PAIRS}" | sed 's/^/  /'
    pass "Found $(printf '%s\n' "${ACCEPT_PAIRS}" | grep -c .) fabric new-flow accept pair(s)"
fi

# ── MR8: Cross-check CPM control-plane.json ────────────────────────────
echo "--- MR8: CPM control-plane.json cross-check ---"
CPM_JSON="/etc/network-artifacts/control-plane.json"
CPM_RELATIONS=""
count_field() {
    local n
    n=$(ssh_cmd "grep -c '\"$1\"' ${CPM_JSON} 2>/dev/null" 2>/dev/null || true)
    n=$(printf '%s\n' "${n}" | grep -oE '[0-9]+' | head -1)
    printf '%s' "${n:-0}"
}
if [[ "$(ssh_cmd "test -f ${CPM_JSON} && echo yes || echo no" 2>/dev/null)" != "yes" ]]; then
    fail "CPM control-plane.json not found at ${CPM_JSON} on ${CLAB_HOST} (MR8)"
    FW_INTENT_COUNT=0; POLICY_RULES_COUNT=0; ALLOWED_FLOWS_COUNT=0; ALLOWED_REL_COUNT=0
else
    pass "CPM control-plane.json present on ${CLAB_HOST}"
    FW_INTENT_COUNT="$(count_field firewallIntent)"
    POLICY_RULES_COUNT="$(count_field policyRules)"
    ALLOWED_FLOWS_COUNT="$(count_field allowedFlows)"
    ALLOWED_REL_COUNT="$(count_field allowedRelations)"
    echo "  firewallIntent occurrences: ${FW_INTENT_COUNT}"
    echo "  policyRules occurrences: ${POLICY_RULES_COUNT}"
    echo "  allowedFlows occurrences: ${ALLOWED_FLOWS_COUNT}"
    echo "  allowedRelations occurrences: ${ALLOWED_REL_COUNT}"
    CPM_RELATIONS=$(ssh_cmd "grep -oE '\"id\": *\"[^\"]+\"' ${CPM_JSON} 2>/dev/null | sed 's/.*: *\"//; s/\"//'" 2>/dev/null || true)

    CPM_FW_TOTAL=$((FW_INTENT_COUNT + POLICY_RULES_COUNT + ALLOWED_FLOWS_COUNT + ALLOWED_REL_COUNT))
    # FC8: CPM has firewall data but container has zero forward rules.
    if [[ "${CPM_FW_TOTAL}" -gt 0 && "${FW_RULES_COUNT}" -eq 0 ]]; then
        fail "CPM has firewall rules but policy container has zero forward rules — renderer deployment failure (FC8)"
    fi
    # FC9: CPM has zero firewall data AND container has zero forward rules.
    if [[ "${CPM_FW_TOTAL}" -eq 0 && "${FW_RULES_COUNT}" -eq 0 ]]; then
        fail "CPM has zero firewall rules AND policy container has zero forward rules — CPM/NFM pipeline failure (FC9)"
    fi
fi

# ── FC10/FC11: stateful return coverage + reverse authorization safety ──
echo "--- FC10/FC11: Return contract (stateful return + reverse safety) ---"
evaluate_return_contract "${FW_BODY}" "${CPM_RELATIONS}"
if [[ ${#EVAL_MISSING_STATEFUL[@]} -eq 0 ]]; then
    pass "Every forward allow is covered by ct state established,related return behavior"
else
    echo "Missing stateful-return coverage (D18-NEW return-path gaps):"
    for gap in "${EVAL_MISSING_STATEFUL[@]}"; do echo "  ${gap}"; done
    fail "One or more forward allows lack established,related return behavior (FC10/D18-NEW)"
fi
if [[ ${#EVAL_UNSAFE_REVERSE[@]} -eq 0 ]]; then
    pass "No unsafe reverse-direction new-flow accepts"
else
    echo "Unsafe reverse-direction new-flow accepts:"
    for bad in "${EVAL_UNSAFE_REVERSE[@]}"; do echo "  ${bad}"; done
    fail "Reverse-direction new-flow accept without distinct modeled reverse relation and enforceable scope (FC11)"
fi

echo ""
echo "=== PROBE RESULT: ${OVERALL_RESULT} ==="
echo "Failure conditions (${#FAILURES[@]}):"
if [[ ${#FAILURES[@]} -eq 0 ]]; then
    echo "  None triggered"
else
    for f in "${FAILURES[@]}"; do echo "  - ${f}"; done
fi
echo "Captured ruleset: ${RULESET_FILE}"

# ── Seeded Negative Tests (active, with recovery) ───────────────────────
if [[ "${OVERALL_RESULT}" == "PASS" && "${SKIP_SEEDED_NEGATIVES:-0}" != "1" ]]; then
    echo ""
    echo "=== Seeded Negative Tests ==="
    SN1_OK=0
    SN2_OK=0
    SN3_OK=0

    nft_in_container() {
        ssh_cmd "docker exec ${POLICY_CONTAINER} nft $*"
    }

    stateful_handle() {
        nft_in_container "-a list chain ${FW_FAMILY} ${FW_TABLE_NAME} forward" 2>/dev/null | \
            grep 'ct state established,related' | grep -oE 'handle [0-9]+' | awk '{print $2}' | head -1
    }

    handle_by_comment() {
        nft_in_container "-a list chain ${FW_FAMILY} ${FW_TABLE_NAME} forward" 2>/dev/null | \
            grep -F "$1" | grep -oE 'handle [0-9]+' | awk '{print $2}' | head -1
    }

    refresh_body() {
        FRESH_RULESET=$(nft_in_container "list ruleset" 2>&1)
        forward_body "${FRESH_RULESET}"
    }

    # SN1: Missing stateful return → D18-NEW gap reported.
    echo "--- SN1: Missing stateful return ---"
    SN1_HANDLE="$(stateful_handle)"
    if [[ -z "${SN1_HANDLE}" ]]; then
        fail "SN1: could not locate ct state established,related rule handle"
    else
        nft_in_container "delete rule ${FW_FAMILY} ${FW_TABLE_NAME} forward handle ${SN1_HANDLE}" >/dev/null 2>&1 || fail "SN1: failed to remove stateful return rule"
        SN1_BODY="$(refresh_body)"
        evaluate_return_contract "${SN1_BODY}" "${CPM_RELATIONS}"
        if [[ ${#EVAL_MISSING_STATEFUL[@]} -gt 0 ]]; then
            SN1_OK=1
            pass "SN1: D18-NEW return-path gap detected after removing stateful return: ${EVAL_MISSING_STATEFUL[0]}"
        else
            fail "SN1: probe did not report D18-NEW gap after stateful return removal"
        fi
        # Recovery: restore established,related at the top of the chain.
        nft_in_container "insert rule ${FW_FAMILY} ${FW_TABLE_NAME} forward ct state established,related accept" >/dev/null 2>&1 || fail "SN1: failed to restore stateful return rule"
        SN1_BODY="$(refresh_body)"
        evaluate_return_contract "${SN1_BODY}" "${CPM_RELATIONS}"
        if [[ ${#EVAL_MISSING_STATEFUL[@]} -ne 0 ]]; then
            fail "SN1: recovery failed — stateful return coverage still missing"
        fi
    fi

    # SN3: Unsafe reverse accept → rejected; recovery removes it.
    echo "--- SN3: Unsafe reverse new-flow accept ---"
    nft_in_container "add rule ${FW_FAMILY} ${FW_TABLE_NAME} forward iifname ens99 oifname ens98 tcp dport 9099 counter accept comment \\\"SN3-forward-relation\\\"" >/dev/null 2>&1 || fail "SN3: failed to inject forward relation rule"
    nft_in_container "add rule ${FW_FAMILY} ${FW_TABLE_NAME} forward iifname ens98 oifname ens99 accept comment \\\"SN3-seeded-reverse\\\"" >/dev/null 2>&1 || fail "SN3: failed to inject unsafe reverse rule"
    SN3_BODY="$(refresh_body)"
    evaluate_return_contract "${SN3_BODY}" "${CPM_RELATIONS}"
    SN3_HIT=""
    for bad in "${EVAL_UNSAFE_REVERSE[@]:-}"; do
        if printf '%s\n' "${bad}" | grep -q 'ens98->ens99'; then SN3_HIT="${bad}"; fi
    done
    if [[ -n "${SN3_HIT}" ]]; then
        SN3_OK=1
        pass "SN3: unsafe reverse new-flow accept rejected — ${SN3_HIT}"
    else
        fail "SN3: injected interface-only reverse accept ens98->ens99 was not rejected"
    fi
    for c in SN3-seeded-reverse SN3-forward-relation; do
        H="$(handle_by_comment "${c}")"
        [[ -n "${H}" ]] && nft_in_container "delete rule ${FW_FAMILY} ${FW_TABLE_NAME} forward handle ${H}" >/dev/null 2>&1
    done
    SN3_BODY="$(refresh_body)"
    evaluate_return_contract "${SN3_BODY}" "${CPM_RELATIONS}"
    if [[ ${#EVAL_UNSAFE_REVERSE[@]} -ne 0 || ${#EVAL_MISSING_STATEFUL[@]} -ne 0 ]]; then
        fail "SN3: recovery failed — ruleset not clean after removing seeded rules"
    fi

    # SN2: Zero rules flush → FC6 and FC7 both fail; restore afterwards.
    echo "--- SN2: Zero rules flush ---"
    SN2_SAVED="$(refresh_body)"
    nft_in_container "flush chain ${FW_FAMILY} ${FW_TABLE_NAME} forward" >/dev/null 2>&1 || fail "SN2: failed to flush forward chain"
    SN2_BODY="$(refresh_body)"
    SN2_COUNT=$(printf '%s\n' "${SN2_BODY}" | grep -c . || true)
    SN2_FABRIC=$(new_flow_accepts "${SN2_BODY}" | grep -cE 'iifname' || true)
    if [[ "${SN2_COUNT}" -eq 0 && "${SN2_FABRIC}" -eq 0 ]]; then
        SN2_OK=1
        pass "SN2: FC6 (rule count 0) and FC7 (zero fabric accepts) both trigger after flush"
    else
        fail "SN2: expected zero rules after flush, got count=${SN2_COUNT} fabric=${SN2_FABRIC}"
    fi
    # Recovery: restore the saved forward chain rules in original order.
    while IFS= read -r rule; do
        [[ -z "${rule}" ]] && continue
        restored=$(printf '%s\n' "${rule}" | sed -e 's/counter packets [0-9]* bytes [0-9]*/counter/' -e 's/comment "\([^"]*\)"/comment \\"\1\\"/')
        nft_in_container "add rule ${FW_FAMILY} ${FW_TABLE_NAME} forward ${restored}" >/dev/null 2>&1 || fail "SN2: failed to restore rule: ${rule}"
    done <<< "${SN2_SAVED}"
    SN2_BODY="$(refresh_body)"
    SN2_RESTORED=$(printf '%s\n' "${SN2_BODY}" | grep -c . || true)
    SN2_EXPECTED=$(printf '%s\n' "${SN2_SAVED}" | grep -c . || true)
    if [[ "${SN2_RESTORED}" -ne "${SN2_EXPECTED}" ]]; then
        fail "SN2: recovery failed — restored ${SN2_RESTORED}/${SN2_EXPECTED} rules"
    fi
    evaluate_return_contract "${SN2_BODY}" "${CPM_RELATIONS}"
    if [[ ${#EVAL_UNSAFE_REVERSE[@]} -ne 0 || ${#EVAL_MISSING_STATEFUL[@]} -ne 0 ]]; then
        fail "SN2: recovery failed — return contract not clean after restore"
    fi

    echo ""
    echo "=== SEEDED NEGATIVE RESULTS ==="
    echo "SN1 (missing stateful return -> D18-NEW): $([[ ${SN1_OK} -eq 1 ]] && echo PASS || echo FAIL)"
    echo "SN2 (zero rules flush -> FC6+FC7): $([[ ${SN2_OK} -eq 1 ]] && echo PASS || echo FAIL)"
    echo "SN3 (unsafe reverse accept rejected): $([[ ${SN3_OK} -eq 1 ]] && echo PASS || echo FAIL)"
fi

echo ""
echo "=== FINAL RESULT ==="
if [[ ${#FAILURES[@]} -eq 0 ]]; then
    echo "HAT probe PASS — forward authorization + stateful return contract verified on live CLAB runtime"
else
    OVERALL_RESULT="FAIL"
    echo "HAT probe FAIL — ${#FAILURES[@]} failure(s)"
    for f in "${FAILURES[@]}"; do echo "  - ${f}"; done
fi

[[ "${OVERALL_RESULT}" == "PASS" ]] && exit 0 || exit 1
