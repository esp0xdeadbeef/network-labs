#!/usr/bin/env bash
# GAMP-ID: FS-950-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: focused SMT construction test — s-router-prod offline latest-pin
#             migration documentation module (scripts/s-router-prod-offline-pin-migration.py)
#
# Synthetic fixtures only. No Nix evaluation, no live target, no SSH, no ping,
# no VM start, no image registration, no deploy, no service/timer query, no
# canary execution, no HAT, no SAT, no production acceptance. All fixtures are
# written into an isolated mktemp dir removed on EXIT.
#
# Covers the 13 construction-handoff requirements of the SMS:
#   CH1-CH3  synthetic pin manifests, audit facts, redacted state schemas
#   CH4      all 10 minimum package sections emitted
#   CH5-CH6  all 6 seeded negatives reject + all 6 recovery fixtures pass
#   CH7      no acceptance-status claim in the emitted package
#   CH8      explicit autoStart=false in the promotion-gate specification
#   CH9      every durable-state entry carries all 9 required fields
#   CH10     override ledger classifies every override with rationale
#   CH11     parity matrix carries all 7 required assertions
#   CH12     module executes nothing (static no-execution scan)
#   CH13     declarative path-class metadata accepted; acquisition rejected
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
module="${repo_root}/scripts/s-router-prod-offline-pin-migration.py"
trace_id="FS-950-HDS-010-SDS-010-SMS-050"

tmp_dir="$(mktemp -d -t fs950-sms050-test.XXXXXX)"
trap 'rm -rf "${tmp_dir}"' EXIT

checks=0
fail() { echo "FAIL ${trace_id}: $*" >&2; exit 1; }
note() { checks=$((checks + 1)); echo "PASS [${checks}]: $*"; }

[[ -f "${module}" ]] || fail "module missing: ${module}"
python3 -m py_compile "${module}" || fail "module does not compile"
note "module present and compiles"

# ---------------------------------------------------------------------------
# Synthetic baseline fixtures (CH1, CH2, CH3)
# ---------------------------------------------------------------------------
write_baseline() {
  local d="$1"
  mkdir -p "${d}"

  cat > "${d}/source-pins.json" << 'EOF'
{
  "comment": "synthetic source baseline pins derived from versioned lock metadata",
  "pins": {
    "network-compiler": "aaaaaaaa1111aaaaaaaa1111aaaaaaaa1111aaaa",
    "network-control-plane-model": "bbbbbbbb2222bbbbbbbb2222bbbbbbbb2222bbbb",
    "network-forwarding-model": "cccccccc3333cccccccc3333cccccccc3333cccc",
    "network-renderer-nixos": "dddddddd4444dddddddd4444dddddddd4444dddd",
    "nixos-network-compiler": "aaaaaaaa1111aaaaaaaa1111aaaaaaaa1111aaaa"
  }
}
EOF

  cat > "${d}/target-pins.json" << 'EOF'
{
  "comment": "synthetic candidate target pins (parameterized, user-supplied)",
  "pins": {
    "network-compiler": "e2da177f0000e2da177f0000e2da177f0000e2da",
    "network-control-plane-model": "15f8190e000015f8190e000015f8190e000015f8",
    "network-forwarding-model": "8894c54100008894c54100008894c54100008894",
    "network-renderer-nixos": "ebbb3b0f0000ebbb3b0f0000ebbb3b0f0000ebbb",
    "nixos-network-compiler": "e2da177f0000e2da177f0000e2da177f0000e2da"
  }
}
EOF

  cat > "${d}/coherent-stack.json" << 'EOF'
{
  "relation": "synthetic coherent network-stack pin set locked together",
  "members": [
    "network-compiler",
    "network-control-plane-model",
    "network-forwarding-model",
    "network-renderer-nixos",
    "nixos-network-compiler"
  ],
  "coherent": true
}
EOF

  cat > "${d}/audit-facts.json" << 'EOF'
{
  "comment": "synthetic user-supplied audit facts matching the override classification evidence",
  "overrides": [
    {"name": "hostName-lib.mkForce", "classification": "remove",
     "rationale": "audit-fact:synthetic-candidate-evaluation — effective hostname remains s-router-prod after removal"},
    {"name": "qemu-mkForce", "classification": "retain",
     "rationale": "audit-fact:synthetic-candidate-evaluation — removal adds default user networking and duplicate vmbr4 NICs"},
    {"name": "kea-legacy-lease-paths", "classification": "retain",
     "rationale": "audit-fact:synthetic-candidate-evaluation — removal loses StateDirectory=kea and /var/lib/kea/<vlan>.leases semantics"},
    {"name": "nebula-public-ingress-hotpatch", "classification": "retain",
     "rationale": "audit-fact:synthetic-candidate-evaluation — removal loses all 4242 DNAT/SNAT/forward rules and required return routes"},
    {"name": "reservation-overrides-runtime-secret-bindings", "classification": "retain",
     "rationale": "audit-fact:synthetic-candidate-evaluation — protected references, never copied in plaintext"},
    {"name": "vlan2-vlan3-return-hotpatch", "classification": "conditional",
     "rationale": "audit-fact:synthetic-candidate-evaluation — removal blocked until the exact offline parity predicate passes"}
  ],
  "semanticDeltas": [
    {"id": "policy-broad-table-routes",
     "description": "candidate loses some broad policy-table routes",
     "reference": "audit-fact:synthetic-candidate-evaluation"},
    {"id": "stateful-return-rules",
     "description": "policy and upstream-selector gain stateful ct state established,related return rules",
     "reference": "FS-950-HDS-010-SDS-010-SMS-050"}
  ],
  "knownGaps": [
    "Nebula 4242 ingress assertions previously missing upstream; asserted in this package"
  ]
}
EOF

  cat > "${d}/state-schema.json" << 'EOF'
{
  "comment": "synthetic redacted state-schema declarations: Kea leases, reservation overrides, Nebula secret references, QEMU configuration",
  "entries": [
    {"name": "kea-lease-state-per-vlan",
     "contentClass": "durable-modeled-state",
     "sourcePathClass": "/var/lib/kea/<vlan>.leases under systemd StateDirectory=kea",
     "targetPathClass": "/var/lib/kea/<vlan>.leases under systemd StateDirectory=kea",
     "ownerMode": "kea:kea 0640",
     "backupArtifact": "offline-export/kea-leases-<vlan>.tar",
     "checksum": "sha256 recorded per exported lease file",
     "conversionProcedure": "none — retain schema per FS-860/FS-880",
     "validationPredicate": "memfile parses; leases belong to the declared VLAN namespace",
     "rollbackSource": "offline-export/kea-leases-<vlan>.tar",
     "idempotenceKey": "kea-leases-per-vlan-memfile-v1"},
    {"name": "kea-reservation-overrides",
     "contentClass": "durable-modeled-state",
     "sourcePathClass": "/persist/kea/reservation-overrides",
     "targetPathClass": "/persist/kea/reservation-overrides",
     "ownerMode": "root:root 0600",
     "reservationSecretRef": "secret://kea/prod/reservation-overrides",
     "backupArtifact": "offline-export/kea-reservation-overrides.redacted.json",
     "checksum": "sha256 recorded for the redacted reference file",
     "conversionProcedure": "none — protected references only",
     "validationPredicate": "entries resolve to secret:// references only",
     "rollbackSource": "offline-export/kea-reservation-overrides.redacted.json",
     "idempotenceKey": "kea-reservation-overrides-refs-v1"},
    {"name": "nebula-secret-material",
     "contentClass": "durable-secret-references",
     "sourcePathClass": "/persist/nebula",
     "targetPathClass": "/persist/nebula",
     "ownerMode": "root:root 0600",
     "caKeyRef": "secret://nebula/prod/ca",
     "backupArtifact": "offline-export/nebula-secret-references.json",
     "checksum": "sha256 recorded for the reference file",
     "conversionProcedure": "none — protected references only",
     "validationPredicate": "reference file contains only secret:// references",
     "rollbackSource": "offline-export/nebula-secret-references.json",
     "idempotenceKey": "nebula-secret-references-v1"},
    {"name": "qemu-vm-contract-declaration",
     "contentClass": "regenerated-contract",
     "sourcePathClass": "versioned repo QEMU contract (single vmbr4 NIC)",
     "targetPathClass": "regenerated from target pins, identical semantics",
     "ownerMode": "not-applicable",
     "backupArtifact": "versioned repo history",
     "checksum": "git revision hash of the declaration",
     "conversionProcedure": "regenerate from target pins",
     "validationPredicate": "NIC cardinality preserved; no default user networking",
     "rollbackSource": "versioned repo history at source pins",
     "idempotenceKey": "qemu-contract-parity-v1"}
  ]
}
EOF

  cat > "${d}/migration-plan.json" << 'EOF'
{
  "steps": [
    "record source baseline pins from versioned lock metadata",
    "bump flake.lock to the candidate coherent target pin set (floating refs per FS-985)",
    "build the candidate offline artifact without registering or starting any image",
    "review this documentation package as the offline artifact review gate"
  ],
  "rollback": {
    "steps": [
      "restore flake.lock to the recorded source pin set",
      "restore durable state from backup artifacts and re-verify checksums"
    ],
    "backupArtifacts": ["offline-export/kea-leases-<vlan>.tar"],
    "idempotenceKeys": ["kea-leases-per-vlan-memfile-v1"],
    "checksumVerification": "sha256 comparison of every restored artifact against the provenance manifest"
  },
  "abort": {
    "trigger": "failed checksum, missing backup artifact, or unapproved semantic delta",
    "procedure": "halt remaining steps; source baseline stays authoritative"
  }
}
EOF

  cat > "${d}/parity-matrix.json" << 'EOF'
{
  "assertions": [
    {"topic": "nebula-4242-dnat-snat-forward-return-routes",
     "expectation": "all Nebula 4242 DNAT/SNAT/forward rules and required return routes present",
     "reference": "FS-950-HDS-010-SDS-010-SMS-050"},
    {"topic": "stateful-return-semantics",
     "expectation": "ct state established,related return rules present",
     "reference": "FS-950-HDS-010-SDS-010-SMS-050"},
    {"topic": "policy-route-changes",
     "expectation": "broad policy-table route loss recorded and owned",
     "reference": "audit-fact:synthetic-candidate-evaluation"},
    {"topic": "qemu-nic-cardinality",
     "expectation": "exactly one vmbr4 NIC, no default user networking",
     "reference": "audit-fact:synthetic-candidate-evaluation"},
    {"topic": "kea-state-locations",
     "expectation": "StateDirectory=kea and /var/lib/kea/<vlan>.leases retained",
     "reference": "FS-880-HDS-010-SDS-010-SMS-010"},
    {"topic": "secret-reference-preservation",
     "expectation": "secret:// references preserved; no plaintext secrets",
     "reference": "FS-950-HDS-010-SDS-010-SMS-050"},
    {"topic": "host-container-equivalence",
     "expectation": "host networking, QEMU contract and containers equivalent in the controlled snapshot",
     "reference": "audit-fact:synthetic-candidate-evaluation"}
  ]
}
EOF
}

# run_module <input_dir> <output_dir> <stderr_file>; echoes exit code
run_module() {
  local in_dir="$1" out_dir="$2" err_file="$3" rc=0
  python3 "${module}" --input-dir "${in_dir}" --output-dir "${out_dir}" \
    >/dev/null 2>"${err_file}" || rc=$?
  echo "${rc}"
}

# ---------------------------------------------------------------------------
# CH4: baseline accepted, all 10 minimum package sections emitted
# ---------------------------------------------------------------------------
base_in="${tmp_dir}/baseline/inputs"
base_out="${tmp_dir}/baseline/package"
write_baseline "${base_in}"
rc="$(run_module "${base_in}" "${base_out}" "${tmp_dir}/baseline.err")"
[[ "${rc}" -eq 0 ]] || { cat "${tmp_dir}/baseline.err" >&2; fail "baseline synthetic fixtures rejected (exit ${rc})"; }
note "CH1-CH3: synthetic pin manifests, audit facts, redacted state schemas accepted"

expected_sections=(
  "01-README-no-live-boundary.md"
  "02-pin-manifests.md"
  "03-semantic-diff-parity-matrix.md"
  "04-override-disposition-ledger.md"
  "05-persistent-state-inventory.md"
  "06-offline-migration-plan.md"
  "07-backup-checksum-rollback-abort.md"
  "08-promotion-gate-specification.md"
  "09-known-gaps-blocked-removals.md"
  "10-provenance-redaction-manifest.md"
)
for section in "${expected_sections[@]}"; do
  [[ -s "${base_out}/${section}" ]] || fail "CH4: missing/empty package section ${section}"
done
note "CH4: all 10 minimum package sections emitted"

# ---------------------------------------------------------------------------
# CH7: no acceptance-status claim in the emitted package
# ---------------------------------------------------------------------------
if grep -rniE '\bOK\b|production[- ]ready|canary[- ]ready' "${base_out}" >/dev/null; then
  fail "CH7: emitted package carries an acceptance-status claim"
fi
note "CH7: no acceptance-status claim in emitted package"

# ---------------------------------------------------------------------------
# CH8: explicit autoStart=false in the promotion-gate specification
# ---------------------------------------------------------------------------
grep -q 'autoStart=false' "${base_out}/08-promotion-gate-specification.md" \
  || fail "CH8: promotion-gate specification lacks autoStart=false"
note "CH8: promotion-gate specification carries autoStart=false"

# ---------------------------------------------------------------------------
# CH9: every durable-state entry carries all 9 required fields
# ---------------------------------------------------------------------------
python3 - "${base_out}/state-inventory.json" << 'PYEOF' || fail "CH9: durable-state entry incomplete"
import json, sys
required = ("sourcePathClass", "targetPathClass", "ownerMode", "backupArtifact",
            "checksum", "conversionProcedure", "validationPredicate",
            "rollbackSource", "idempotenceKey")
doc = json.load(open(sys.argv[1]))
entries = doc["entries"]
assert entries, "no durable-state entries"
for entry in entries:
    for field in required:
        value = entry.get(field)
        assert isinstance(value, str) and value.strip(), \
            f"entry {entry.get('name')} lacks {field}"
PYEOF
note "CH9: every durable-state entry carries all 9 required fields"

# ---------------------------------------------------------------------------
# CH10: override ledger classifies every override with rationale
# ---------------------------------------------------------------------------
python3 - "${base_out}/override-ledger.json" << 'PYEOF' || fail "CH10: override ledger unclassified entry"
import json, sys
doc = json.load(open(sys.argv[1]))
overrides = doc["overrides"]
assert overrides, "no overrides in ledger"
for o in overrides:
    assert o.get("classification") in ("retain", "remove", "conditional"), \
        f"override {o.get('name')} unclassified"
    assert isinstance(o.get("rationale"), str) and o["rationale"].strip(), \
        f"override {o.get('name')} lacks rationale"
PYEOF
note "CH10: override ledger classifies every override with explicit rationale"

# ---------------------------------------------------------------------------
# CH11: parity matrix includes all required assertions
# ---------------------------------------------------------------------------
python3 - "${base_out}/parity-matrix.json" << 'PYEOF' || fail "CH11: parity matrix missing required assertion"
import json, sys
required = {
    "nebula-4242-dnat-snat-forward-return-routes",
    "stateful-return-semantics",
    "policy-route-changes",
    "qemu-nic-cardinality",
    "kea-state-locations",
    "secret-reference-preservation",
    "host-container-equivalence",
}
doc = json.load(open(sys.argv[1]))
topics = {a["topic"] for a in doc["assertions"]}
missing = required - topics
assert not missing, f"missing parity assertions: {sorted(missing)}"
PYEOF
note "CH11: parity matrix carries all 7 required assertions"

# ---------------------------------------------------------------------------
# CH12: module executes nothing (static no-execution scan of module source)
# ---------------------------------------------------------------------------
if grep -nE '^\s*(import|from)\s+(subprocess|socket|asyncio|paramiko|pexpect|pty|telnetlib|ftplib|http|urllib|requests|shutil|ctypes)\b' "${module}"; then
  fail "CH12: module imports an execution/network-capable library"
fi
if grep -nE 'os\.(system|popen|exec[a-z]*|spawn[a-z]*)|subprocess\.|socket\.|eval\(|__import__' "${module}"; then
  fail "CH12: module contains an execution/network call"
fi
note "CH12: module performs no execution (no SSH/ping/probe/VM/deploy/Nix-eval/service-query surface)"

# ---------------------------------------------------------------------------
# Seeded negatives (CH5) + recoveries (CH6). Each case copies the baseline
# into an isolated dir and mutates exactly one input file.
# ---------------------------------------------------------------------------
new_case() {
  local name="$1"
  local d="${tmp_dir}/${name}/inputs"
  mkdir -p "${tmp_dir}/${name}"
  cp -r "${base_in}" "${d}"
  echo "${d}"
}

expect_reject() {
  local name="$1" in_dir="$2" diagnostic="$3"
  local err="${tmp_dir}/${name}.err" rc
  rc="$(run_module "${in_dir}" "${tmp_dir}/${name}/package" "${err}")"
  [[ "${rc}" -ne 0 ]] || fail "${name}: module accepted a seeded negative"
  grep -q "diagnostic\.${diagnostic}" "${err}" \
    || { cat "${err}" >&2; fail "${name}: expected diagnostic.${diagnostic}"; }
}

expect_accept() {
  local name="$1" in_dir="$2"
  local err="${tmp_dir}/${name}.err" rc
  rc="$(run_module "${in_dir}" "${tmp_dir}/${name}/package" "${err}")"
  [[ "${rc}" -eq 0 ]] || { cat "${err}" >&2; fail "${name}: recovery fixture rejected"; }
}

# --- SN1: live acquisition rejected; declarative path-class accepted --------
sn1_dir="$(new_case sn1)"
python3 - "${sn1_dir}/audit-facts.json" << 'PYEOF'
import json, sys
p = sys.argv[1]
doc = json.load(open(p))
doc["acquire"] = {"method": "ssh", "command": "nft list ruleset", "host": "s-router-prod"}
json.dump(doc, open(p, "w"), indent=2)
PYEOF
expect_reject "sn1" "${sn1_dir}" "live-surface-reference"
grep -q "ssh" "${tmp_dir}/sn1.err" || fail "SN1: diagnostic does not name the prohibited method"
note "SN1: acquisition method targeting a live surface rejected with diagnostic.live-surface-reference"

sn1r_dir="$(new_case sn1-recovery)"
python3 - "${sn1r_dir}/audit-facts.json" << 'PYEOF'
import json, sys
p = sys.argv[1]
doc = json.load(open(p))
doc["stateObservation"] = {
    "sourcePathClass": "/var/lib/kea/<vlan>.leases",
    "targetPathClass": "/persist/kea",
}
json.dump(doc, open(p, "w"), indent=2)
PYEOF
expect_accept "sn1-recovery" "${sn1r_dir}"
grep -q "diagnostic.live-surface-reference" "${tmp_dir}/sn1-recovery.err" \
  && fail "CH13: declarative path-class metadata wrongly flagged as live acquisition"
note "SN1 recovery + CH13: declarative sourcePathClass/targetPathClass naming production paths accepted"

# --- SN2: plaintext secret rejected; redacted reference accepted ------------
sn2_dir="$(new_case sn2)"
python3 - "${sn2_dir}/state-schema.json" << 'PYEOF'
import json, sys
p = sys.argv[1]
doc = json.load(open(p))
doc["entries"][2]["psk"] = "supersecretkey12345"
json.dump(doc, open(p, "w"), indent=2)
PYEOF
expect_reject "sn2" "${sn2_dir}" "plaintext-secret-detected"
grep -q "psk" "${tmp_dir}/sn2.err" || fail "SN2: diagnostic does not name the field"
note "SN2: plaintext secret rejected with diagnostic.plaintext-secret-detected"

sn2r_dir="$(new_case sn2-recovery)"
python3 - "${sn2r_dir}/state-schema.json" << 'PYEOF'
import json, sys
p = sys.argv[1]
doc = json.load(open(p))
doc["entries"][2]["psk_ref"] = "secret://nebula/prod/ca"
json.dump(doc, open(p, "w"), indent=2)
PYEOF
expect_accept "sn2-recovery" "${sn2r_dir}"
note "SN2 recovery: redacted secret:// reference accepted"

# --- SN3: missing Kea state mapping rejected; restored mapping accepted -----
sn3_dir="$(new_case sn3)"
python3 - "${sn3_dir}/state-schema.json" << 'PYEOF'
import json, sys
p = sys.argv[1]
doc = json.load(open(p))
doc["entries"] = [e for e in doc["entries"]
                  if "kea-lease" not in e["name"]]
json.dump(doc, open(p, "w"), indent=2)
PYEOF
expect_reject "sn3" "${sn3_dir}" "kea-state-mapping-missing"
note "SN3: missing Kea lease-state mapping rejected with diagnostic.kea-state-mapping-missing"

sn3r_dir="$(new_case sn3-recovery)"
expect_accept "sn3-recovery" "${sn3r_dir}"
note "SN3 recovery: restored Kea lease-state entries (FS-860/FS-880 fields) accepted"

# --- SN4: unclassified override rejected; classified override accepted ------
sn4_dir="$(new_case sn4)"
python3 - "${sn4_dir}/audit-facts.json" << 'PYEOF'
import json, sys
p = sys.argv[1]
doc = json.load(open(p))
doc["overrides"].append({"name": "mystery-hotpatch"})
json.dump(doc, open(p, "w"), indent=2)
PYEOF
expect_reject "sn4" "${sn4_dir}" "override-unclassified"
grep -q "mystery-hotpatch" "${tmp_dir}/sn4.err" || fail "SN4: diagnostic does not name the entry"
note "SN4: unclassified override rejected with diagnostic.override-unclassified"

sn4r_dir="$(new_case sn4-recovery)"
python3 - "${sn4r_dir}/audit-facts.json" << 'PYEOF'
import json, sys
p = sys.argv[1]
doc = json.load(open(p))
doc["overrides"].append({
    "name": "mystery-hotpatch",
    "classification": "conditional",
    "rationale": "audit-fact:synthetic-candidate-evaluation — removal blocked pending parity predicate",
})
json.dump(doc, open(p, "w"), indent=2)
PYEOF
expect_accept "sn4-recovery" "${sn4r_dir}"
note "SN4 recovery: classified override with traceable rationale accepted"

# --- SN5: missing rollback/checksum rejected; complete plan accepted --------
sn5_dir="$(new_case sn5)"
python3 - "${sn5_dir}/migration-plan.json" << 'PYEOF'
import json, sys
p = sys.argv[1]
doc = json.load(open(p))
doc.pop("rollback", None)
doc.pop("abort", None)
json.dump(doc, open(p, "w"), indent=2)
PYEOF
expect_reject "sn5" "${sn5_dir}" "rollback-plan-missing"
note "SN5: missing rollback/checksum plan rejected with diagnostic.rollback-plan-missing"

sn5r_dir="$(new_case sn5-recovery)"
expect_accept "sn5-recovery" "${sn5r_dir}"
note "SN5 recovery: complete rollback/abort plan with checksums and idempotence keys accepted"

# --- SN6: parity matrix omitting Nebula 4242 ingress rejected ---------------
sn6_dir="$(new_case sn6)"
python3 - "${sn6_dir}/parity-matrix.json" << 'PYEOF'
import json, sys
p = sys.argv[1]
doc = json.load(open(p))
doc["assertions"] = [a for a in doc["assertions"]
                     if a["topic"] != "nebula-4242-dnat-snat-forward-return-routes"]
json.dump(doc, open(p, "w"), indent=2)
PYEOF
expect_reject "sn6" "${sn6_dir}" "parity-assertion-missing"
grep -q "nebula-4242" "${tmp_dir}/sn6.err" || fail "SN6: diagnostic does not name the Nebula 4242 assertion"
note "SN6: parity matrix omitting Nebula 4242 ingress rejected with diagnostic.parity-assertion-missing"

sn6r_dir="$(new_case sn6-recovery)"
expect_accept "sn6-recovery" "${sn6r_dir}"
note "SN6 recovery: parity matrix with Nebula 4242 DNAT/SNAT/forward/return assertions accepted"

# ---------------------------------------------------------------------------
# Controlled package review: the committed repo package must match the module
# output for the committed inputs (documentation output stays current).
# ---------------------------------------------------------------------------
repo_pkg="${repo_root}/s-router-prod-migration-documentation/package"
repo_inputs="${repo_root}/s-router-prod-migration-documentation/inputs"
if [[ -d "${repo_pkg}" && -d "${repo_inputs}" ]]; then
  regen_out="${tmp_dir}/repo-regen"
  rc="$(run_module "${repo_inputs}" "${regen_out}" "${tmp_dir}/repo-regen.err")"
  [[ "${rc}" -eq 0 ]] || { cat "${tmp_dir}/repo-regen.err" >&2; fail "committed repo inputs rejected by module"; }
  diff -r "${regen_out}" "${repo_pkg}" >/dev/null \
    || fail "committed package differs from module output for committed inputs (regenerate it)"
  note "committed s-router-prod-migration-documentation package is current module output"
else
  fail "committed package or inputs missing under s-router-prod-migration-documentation/"
fi

echo
echo "PASS ${trace_id}: ${checks}/${checks} checks passed (13 construction-handoff requirements, 6 seeded negatives, 6 recoveries; synthetic fixtures only, no live access)"
