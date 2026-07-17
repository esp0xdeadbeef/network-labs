#!/usr/bin/env python3
# GAMP-ID: FS-950-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: CMC — s-router-prod offline latest-pin migration documentation module
#
# Deterministic offline migration-planning/documentation module owned by
# network-labs. Consumes versioned pin manifests, a coherent-stack relation,
# user-supplied audit facts, redacted state-schema declarations, a migration
# plan, a parity matrix, and an optional pre-exported offline snapshot
# manifest. It never acquires live data itself: no subprocess, no sockets,
# no SSH, no Nix evaluation, no systemd/QEMU/VM/remote access, no secret
# stores. Declarative/redacted path-class metadata strings (sourcePathClass,
# targetPathClass) may name production path semantics — the module never
# opens, stats, reads, hashes, enumerates, or executes against those paths.
#
# Trace chain: FS-950 -> FS-950-HDS-010 -> FS-950-HDS-010-SDS-010 ->
#              FS-950-HDS-010-SDS-010-SMS-050
#
# Exit codes: 0 = package emitted; 1 = fail-closed validation diagnostic.
# Diagnostics are written to stderr, one per line, prefixed 'diagnostic.'.

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

TRACE_ID = "FS-950-HDS-010-SDS-010-SMS-050"

# Live/runtime filesystem prefixes this module must never touch (MR/FC no-live
# boundary). Input/output directories under these prefixes are rejected.
LIVE_PATH_PREFIXES = ("/run", "/etc", "/var/lib", "/persist", "/sys", "/proc")

# Prohibited acquisition methods (FC1). These describe live/remote/runtime
# data acquisition; they are rejected wherever they appear in an input.
FORBIDDEN_ACQUISITION_METHODS = {
    "read", "stat", "open", "hash", "enumerate", "list", "exec", "execute",
    "ssh", "scp", "rsync", "curl", "wget", "ping", "probe",
    "nixos-rebuild", "systemctl", "nix-eval", "nix", "qemu", "virsh",
}

# Keys that carry declarative/redacted path-class metadata. Their string
# values may name production path semantics; they are schema descriptions,
# not acquisition operations (SMS Scope, FC1, SN1).
DECLARATIVE_PATH_CLASS_KEYS = {"sourcePathClass", "targetPathClass"}

# Secret-ish field names (FC2). Values must be redacted references
# (secret://...); keys ending in Ref/_ref are already references.
SECRET_KEY_RE = re.compile(
    r"^(psk|password|passphrase|private[_-]?key|secret|token|api[_-]?key|"
    r"ca[_-]?key|shared[_-]?key)$",
    re.IGNORECASE,
)
SECRET_REF_PREFIX = "secret://"

# Required fields for every durable-state entry (MR6 / FC4).
DURABLE_STATE_REQUIRED_FIELDS = (
    "sourcePathClass",
    "targetPathClass",
    "ownerMode",
    "backupArtifact",
    "checksum",
    "conversionProcedure",
    "validationPredicate",
    "rollbackSource",
    "idempotenceKey",
)

# Required parity assertion topics (MR9 / FC6).
REQUIRED_PARITY_TOPICS = (
    "nebula-4242-dnat-snat-forward-return-routes",
    "stateful-return-semantics",
    "policy-route-changes",
    "qemu-nic-cardinality",
    "kea-state-locations",
    "secret-reference-preservation",
    "host-container-equivalence",
)

# Valid override classifications (MR8 / FC5).
OVERRIDE_CLASSIFICATIONS = {"retain", "remove", "conditional"}

# Acceptance-claim tokens that must never appear in inputs (as status claims)
# or in the emitted package (FC10 / MR3).
ACCEPTANCE_CLAIM_RE = re.compile(
    r"\bOK\b|\bproduction[- ]ready\b|\bcanary[- ]ready\b", re.IGNORECASE
)

INPUT_FILES = {
    "source-pins": "source-pins.json",
    "target-pins": "target-pins.json",
    "coherent-stack": "coherent-stack.json",
    "audit-facts": "audit-facts.json",
    "state-schema": "state-schema.json",
    "migration-plan": "migration-plan.json",
    "parity-matrix": "parity-matrix.json",
}
OPTIONAL_INPUT_FILES = {
    "export-manifest": "export-manifest.json",
}


class Diagnostics:
    def __init__(self):
        self.items = []

    def add(self, code, message):
        self.items.append(f"diagnostic.{code}: {message} [trace {TRACE_ID}]")

    def flush_and_maybe_exit(self):
        if self.items:
            for item in self.items:
                print(item, file=sys.stderr)
            sys.exit(1)


def walk(node, path="$"):
    """Yield (json_path, key, value) for every dict item in the tree."""
    if isinstance(node, dict):
        for key, value in node.items():
            yield (f"{path}.{key}", key, value)
            yield from walk(value, f"{path}.{key}")
    elif isinstance(node, list):
        for idx, value in enumerate(node):
            yield from walk(value, f"{path}[{idx}]")


def check_live_surface(diag, doc_name, doc):
    """FC1: reject acquisition methods/commands targeting live surfaces.

    Declarative path-class metadata strings (sourcePathClass,
    targetPathClass) are schema descriptions, not acquisition, and never
    trigger this failure even when they name production path semantics.
    """
    for path, key, value in walk(doc):
        if key in DECLARATIVE_PATH_CLASS_KEYS:
            continue
        if key == "method" and isinstance(value, str):
            if value.strip().lower() in FORBIDDEN_ACQUISITION_METHODS:
                parent = path.rsplit(".", 1)[0]
                target = ""
                diag.add(
                    "live-surface-reference",
                    f"input '{doc_name}' contains prohibited acquisition "
                    f"method '{value}' at {parent}"
                    f"{_describe_target(doc, parent)}",
                )
        if key == "command" and isinstance(value, str) and value.strip():
            diag.add(
                "live-surface-reference",
                f"input '{doc_name}' contains prohibited acquisition "
                f"command '{value}' at {path}",
            )


def _describe_target(doc, parent_path):
    """Best-effort extraction of the acquisition target for the diagnostic."""
    node = doc
    try:
        tokens = re.findall(r"\.([A-Za-z0-9_-]+)|\[(\d+)\]", parent_path)
        for name, idx in tokens:
            node = node[name] if name else node[int(idx)]
        if isinstance(node, dict):
            for target_key in ("path", "target", "host", "url"):
                if target_key in node:
                    return f" targeting '{node[target_key]}'"
    except (KeyError, IndexError, TypeError, ValueError):
        pass
    return ""


def check_plaintext_secrets(diag, doc_name, doc):
    """FC2: reject plaintext secret material; redacted refs are permitted."""
    for path, key, value in walk(doc):
        if key.endswith("Ref") or key.endswith("_ref"):
            continue
        if SECRET_KEY_RE.match(key) and isinstance(value, str):
            if not value.startswith(SECRET_REF_PREFIX):
                diag.add(
                    "plaintext-secret-detected",
                    f"input '{doc_name}' field '{key}' at {path} carries "
                    f"plaintext secret material; use a redacted "
                    f"'{SECRET_REF_PREFIX}' reference",
                )


def check_acceptance_claims_in_inputs(diag, doc_name, doc):
    """FC10 (input side): inputs must not request/carry acceptance status."""
    for path, key, value in walk(doc):
        if key in ("acceptanceStatus", "acceptance_status", "readiness"):
            diag.add(
                "acceptance-claim-prohibited",
                f"input '{doc_name}' carries acceptance/readiness claim "
                f"'{key}' at {path}; this module emits documentation/"
                f"planning output only",
            )


def check_pin_manifests(diag, source_pins, target_pins, coherent_stack):
    """FC3: pin manifests must exist, be complete, and cover the stack."""
    for name, doc in (("source-pins", source_pins), ("target-pins", target_pins)):
        pins = doc.get("pins") if isinstance(doc, dict) else None
        if not isinstance(pins, dict) or not pins:
            diag.add(
                "pin-manifest-incomplete",
                f"'{name}' has no non-empty 'pins' map",
            )
            return
        for repo, rev in pins.items():
            if not isinstance(rev, str) or not re.fullmatch(r"[0-9a-f]{8,40}", rev):
                diag.add(
                    "pin-manifest-incomplete",
                    f"'{name}' pin for '{repo}' is not a revision hash: {rev!r}",
                )
    members = coherent_stack.get("members") if isinstance(coherent_stack, dict) else None
    if not isinstance(members, list) or not members:
        diag.add(
            "pin-manifest-incomplete",
            "'coherent-stack' declaration has no non-empty 'members' list",
        )
        return
    for repo in members:
        for name, doc in (("source-pins", source_pins), ("target-pins", target_pins)):
            if repo not in doc.get("pins", {}):
                diag.add(
                    "pin-manifest-incomplete",
                    f"coherent-stack member '{repo}' missing from '{name}'",
                )


def check_durable_state(diag, state_schema):
    """FC4 + FC9: durable-state completeness and Kea lease-state mapping."""
    entries = state_schema.get("entries") if isinstance(state_schema, dict) else None
    if not isinstance(entries, list) or not entries:
        diag.add(
            "durable-state-entry-incomplete",
            "'state-schema' has no non-empty 'entries' list",
        )
        return
    for entry in entries:
        name = entry.get("name", "<unnamed>") if isinstance(entry, dict) else "<invalid>"
        if not isinstance(entry, dict):
            diag.add(
                "durable-state-entry-incomplete",
                f"durable-state entry {name} is not an object",
            )
            continue
        for field in DURABLE_STATE_REQUIRED_FIELDS:
            value = entry.get(field)
            if not isinstance(value, str) or not value.strip():
                diag.add(
                    "durable-state-entry-incomplete",
                    f"durable-state entry '{name}' lacks required field "
                    f"'{field}'",
                )
    conversion = state_schema.get("approvedSchemaConversion")
    conversion_approved = (
        isinstance(conversion, dict)
        and conversion.get("approved") is True
        and isinstance(conversion.get("reference"), str)
        and conversion["reference"].strip()
    )
    if not conversion_approved:
        has_kea_leases = any(
            isinstance(e, dict)
            and "/var/lib/kea/" in str(e.get("sourcePathClass", ""))
            and ".leases" in str(e.get("sourcePathClass", ""))
            for e in entries
        )
        has_state_directory = any(
            isinstance(e, dict) and "StateDirectory=kea" in json.dumps(e)
            for e in entries
        )
        if not (has_kea_leases and has_state_directory):
            diag.add(
                "kea-state-mapping-missing",
                "durable-state inventory does not retain "
                "'StateDirectory=kea' and '/var/lib/kea/<vlan>.leases' "
                "semantics and no separately approved schema conversion "
                "is declared",
            )


def check_overrides(diag, audit_facts):
    """FC5: every override must be classified with a traceable rationale."""
    overrides = audit_facts.get("overrides") if isinstance(audit_facts, dict) else None
    if not isinstance(overrides, list) or not overrides:
        diag.add(
            "override-unclassified",
            "'audit-facts' has no non-empty 'overrides' ledger",
        )
        return
    for override in overrides:
        name = override.get("name", "<unnamed>") if isinstance(override, dict) else "<invalid>"
        classification = override.get("classification") if isinstance(override, dict) else None
        rationale = override.get("rationale") if isinstance(override, dict) else None
        if classification not in OVERRIDE_CLASSIFICATIONS:
            diag.add(
                "override-unclassified",
                f"override '{name}' has no retain/remove/conditional "
                f"classification",
            )
            continue
        if not isinstance(rationale, str) or not rationale.strip():
            diag.add(
                "override-unclassified",
                f"override '{name}' has no rationale traceable to "
                f"user-supplied audit facts",
            )


def check_rollback(diag, migration_plan):
    """FC8: rollback/abort plan must be present and complete."""
    if not isinstance(migration_plan, dict):
        diag.add("rollback-plan-missing", "'migration-plan' is not an object")
        return
    steps = migration_plan.get("steps")
    if not isinstance(steps, list) or not steps:
        diag.add(
            "rollback-plan-missing",
            "'migration-plan' has no non-empty ordered 'steps' list",
        )
    rollback = migration_plan.get("rollback")
    if not isinstance(rollback, dict):
        diag.add(
            "rollback-plan-missing",
            "'migration-plan' has no 'rollback' plan object",
        )
        return
    for field in ("steps", "backupArtifacts", "idempotenceKeys"):
        value = rollback.get(field)
        if not isinstance(value, list) or not value:
            diag.add(
                "rollback-plan-missing",
                f"rollback plan lacks non-empty '{field}'",
            )
    checksum = rollback.get("checksumVerification")
    if not isinstance(checksum, str) or not checksum.strip():
        diag.add(
            "rollback-plan-missing",
            "rollback plan lacks 'checksumVerification'",
        )
    abort = migration_plan.get("abort")
    if not isinstance(abort, dict) or not abort:
        diag.add(
            "rollback-plan-missing",
            "'migration-plan' has no non-empty 'abort' plan",
        )


def check_parity(diag, parity_matrix):
    """FC6: all required parity assertions must be present with references."""
    assertions = parity_matrix.get("assertions") if isinstance(parity_matrix, dict) else None
    if not isinstance(assertions, list):
        assertions = []
    topics = {
        a.get("topic")
        for a in assertions
        if isinstance(a, dict) and isinstance(a.get("topic"), str)
    }
    for topic in REQUIRED_PARITY_TOPICS:
        if topic not in topics:
            extra = ""
            if "nebula-4242" in topic:
                extra = (
                    " (Nebula 4242 DNAT/SNAT/forward and return-route "
                    "assertions are mandatory)"
                )
            diag.add(
                "parity-assertion-missing",
                f"required parity assertion '{topic}' is missing{extra}",
            )


def check_semantic_deltas(diag, audit_facts):
    """FC7: every semantic delta needs a trace-chain or audit-fact reference."""
    deltas = audit_facts.get("semanticDeltas") if isinstance(audit_facts, dict) else None
    if not isinstance(deltas, list):
        return
    for delta in deltas:
        name = delta.get("id", "<unnamed>") if isinstance(delta, dict) else "<invalid>"
        reference = delta.get("reference") if isinstance(delta, dict) else None
        valid = isinstance(reference, str) and (
            re.search(r"FS-\d+", reference) or reference.startswith("audit-fact:")
        )
        if not valid:
            diag.add(
                "semantic-delta-unapproved",
                f"semantic delta '{name}' lacks an explicit trace-chain ID "
                f"or audit-fact reference",
            )


def load_inputs(diag, input_dir):
    docs = {}
    for key, filename in INPUT_FILES.items():
        path = input_dir / filename
        if not path.is_file():
            code = (
                "pin-manifest-incomplete"
                if key in ("source-pins", "target-pins")
                else "rollback-plan-missing"
                if key == "migration-plan"
                else "parity-assertion-missing"
                if key == "parity-matrix"
                else "durable-state-entry-incomplete"
                if key == "state-schema"
                else "override-unclassified"
                if key == "audit-facts"
                else "pin-manifest-incomplete"
            )
            diag.add(code, f"required input file '{filename}' is missing")
            continue
        try:
            docs[key] = json.loads(path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, UnicodeDecodeError) as exc:
            diag.add(
                "pin-manifest-incomplete"
                if key in ("source-pins", "target-pins")
                else "live-surface-reference",
                f"input file '{filename}' is not valid JSON: {exc}",
            )
    for key, filename in OPTIONAL_INPUT_FILES.items():
        path = input_dir / filename
        if path.is_file():
            try:
                docs[key] = json.loads(path.read_text(encoding="utf-8"))
            except (json.JSONDecodeError, UnicodeDecodeError) as exc:
                diag.add(
                    "live-surface-reference",
                    f"optional input file '{filename}' is not valid JSON: {exc}",
                )
    return docs


def sha256_of(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


NO_LIVE_BOUNDARY = f"""# s-router-prod Offline Latest-Pin Migration Package

Trace: {TRACE_ID}
Owner: network-labs (supplier)

## No-Live Safety Boundary

This package is documentation/planning output only. It was produced offline
from versioned repo files, pin manifests, user-supplied audit facts, redacted
state-schema declarations, and optional user-copied offline-export content.

- No live data acquisition was performed: no SSH, no ping, no packet probe,
  no VM start, no image registration, no deploy, no reboot, no service
  query, no timer query, no Nix evaluation against live targets, no canary
  execution, no HAT, no SAT, and no production acceptance.
- Declarative path-class strings in this package (sourcePathClass,
  targetPathClass) name production path semantics as schema metadata only.
  Nothing in this package opened, stat'ed, read, hashed, enumerated, or
  executed against those live paths.
- This package asserts no acceptance status and no deployment readiness.
  Every promotion step requires separate explicit human authorization.
- Actual export of production state is a later, separately authorized
  maintenance operation; this package only defines the export contract.
"""


def emit_package(output_dir, docs, input_dir):
    output_dir.mkdir(parents=True, exist_ok=True)

    source_pins = docs["source-pins"]["pins"]
    target_pins = docs["target-pins"]["pins"]
    audit_facts = docs["audit-facts"]
    state_entries = docs["state-schema"]["entries"]
    plan = docs["migration-plan"]
    parity = docs["parity-matrix"]

    files = {}

    files["01-README-no-live-boundary.md"] = NO_LIVE_BOUNDARY

    pin_lines = [
        f"# Pin Manifests\n\nTrace: {TRACE_ID}\n",
        "## Source Baseline Pins (derived from versioned lock metadata)\n",
    ]
    for repo, rev in sorted(source_pins.items()):
        pin_lines.append(f"- `{repo}` -> `{rev}`")
    pin_lines.append("\n## Candidate Target Pins (user-supplied, parameterized)\n")
    for repo, rev in sorted(target_pins.items()):
        pin_lines.append(f"- `{repo}` -> `{rev}`")
    pin_lines.append(
        "\nPins are recorded as the initial candidate/audit baseline, not as"
        "\ntimeless requirements. Per FS-985, `flake.nix` uses floating refs and"
        "\n`flake.lock` is the sole authoritative revision-pinning surface."
    )
    coherent = docs["coherent-stack"]
    pin_lines.append("\n## Coherent-Stack Relationship\n")
    pin_lines.append(f"- relation: {coherent.get('relation', '<unspecified>')}")
    for repo in coherent.get("members", []):
        pin_lines.append(f"- member: `{repo}`")
    files["02-pin-manifests.md"] = "\n".join(pin_lines) + "\n"

    diff_lines = [
        f"# Semantic Diff and Parity Matrix\n\nTrace: {TRACE_ID}\n",
        "## Recorded Semantic Deltas (user-supplied, each with owning reference)\n",
    ]
    for delta in audit_facts.get("semanticDeltas", []):
        diff_lines.append(
            f"- {delta.get('id')}: {delta.get('description')} "
            f"(reference: {delta.get('reference')})"
        )
    diff_lines.append(
        "\nA byte-identical snapshot is not required; every allowed semantic"
        "\ndelta above carries an owning trace-chain or audit-fact reference."
    )
    diff_lines.append("\n## Parity Matrix\n")
    for assertion in parity.get("assertions", []):
        diff_lines.append(
            f"- [{assertion.get('topic')}] {assertion.get('expectation')} "
            f"(reference: {assertion.get('reference')})"
        )
    files["03-semantic-diff-parity-matrix.md"] = "\n".join(diff_lines) + "\n"

    ledger_lines = [
        f"# Override / Hotpatch Disposition Ledger\n\nTrace: {TRACE_ID}\n",
    ]
    for override in audit_facts.get("overrides", []):
        ledger_lines.append(
            f"- `{override.get('name')}` — classification: "
            f"**{override.get('classification')}** — rationale: "
            f"{override.get('rationale')}"
        )
    files["04-override-disposition-ledger.md"] = "\n".join(ledger_lines) + "\n"

    state_lines = [
        f"# Persistent-State Inventory and State-Schema Migration Map\n\n"
        f"Trace: {TRACE_ID}\n",
        "Only durable modeled state that must survive is migrated, using",
        "FS-860 and FS-880 contracts. Derived network/rendered configuration",
        "(generated routes, nftables, networkd, renderer output, Nix store",
        "paths, VM images, runtime process state) is regenerated from the",
        "target pins and never migrated as authoritative data.\n",
    ]
    for entry in state_entries:
        state_lines.append(f"## {entry.get('name')}\n")
        for field in ("contentClass",) + DURABLE_STATE_REQUIRED_FIELDS:
            if field in entry:
                state_lines.append(f"- {field}: `{entry[field]}`")
        state_lines.append("")
    files["05-persistent-state-inventory.md"] = "\n".join(state_lines) + "\n"

    plan_lines = [
        f"# Ordered Offline Migration Plan\n\nTrace: {TRACE_ID}\n",
    ]
    for idx, step in enumerate(plan.get("steps", []), start=1):
        plan_lines.append(f"{idx}. {step}")
    files["06-offline-migration-plan.md"] = "\n".join(plan_lines) + "\n"

    rollback = plan.get("rollback", {})
    abort = plan.get("abort", {})
    rb_lines = [
        f"# Backup, Checksum, Idempotence, Rollback and Abort Plan\n\n"
        f"Trace: {TRACE_ID}\n",
        "## Backup Artifacts\n",
    ]
    for artifact in rollback.get("backupArtifacts", []):
        rb_lines.append(f"- {artifact}")
    rb_lines.append("\n## Checksum Verification\n")
    rb_lines.append(f"- {rollback.get('checksumVerification')}")
    rb_lines.append("\n## Idempotence Keys\n")
    for key in rollback.get("idempotenceKeys", []):
        rb_lines.append(f"- {key}")
    rb_lines.append("\n## Ordered Rollback Steps\n")
    for idx, step in enumerate(rollback.get("steps", []), start=1):
        rb_lines.append(f"{idx}. {step}")
    rb_lines.append("\n## Abort Plan\n")
    for key, value in abort.items():
        rb_lines.append(f"- {key}: {value}")
    files["07-backup-checksum-rollback-abort.md"] = "\n".join(rb_lines) + "\n"

    files["08-promotion-gate-specification.md"] = f"""# Candidate -> Canary -> Prod Promotion-Gate Specification

Trace: {TRACE_ID}

This is a future gate definition only. This package does not register or
start any image and does not access the canary or live production
environment. No acceptance status is asserted by this package.

Gate order (each transition requires explicit human authorization):

1. Candidate build from target pins (offline artifact only).
2. Offline artifact review of this documentation package.
3. Non-autostart s-tau canary with `autoStart=false`.
4. Explicit human approval recorded outside this package.
5. Production migration as a separately authorized maintenance operation.

The canary VM definition MUST carry `autoStart=false`; automatic start of
the canary or production image from this package is prohibited.
"""

    gaps_lines = [
        f"# Known Gaps and Blocked Removals\n\nTrace: {TRACE_ID}\n",
    ]
    for gap in audit_facts.get("knownGaps", []):
        gaps_lines.append(f"- {gap}")
    for override in audit_facts.get("overrides", []):
        if override.get("classification") == "conditional":
            gaps_lines.append(
                f"- BLOCKED REMOVAL: `{override.get('name')}` — "
                f"{override.get('rationale')}"
            )
    files["09-known-gaps-blocked-removals.md"] = "\n".join(gaps_lines) + "\n"

    prov_lines = [
        f"# Provenance and Redaction Manifest\n\nTrace: {TRACE_ID}\n",
        "## Input Provenance (sha256 of consumed offline inputs)\n",
    ]
    for filename in sorted(list(INPUT_FILES.values()) + list(OPTIONAL_INPUT_FILES.values())):
        path = input_dir / filename
        if path.is_file():
            prov_lines.append(f"- `{filename}` sha256 `{sha256_of(path)}`")
    prov_lines.append(
        "\n## Redaction Statement\n\n"
        "All secret material in consumed inputs is redacted to "
        "`secret://` references. Reservation overrides and Nebula/other "
        "secret material remain protected references; no plaintext secret "
        "was copied into this package."
    )
    files["10-provenance-redaction-manifest.md"] = "\n".join(prov_lines) + "\n"

    # Machine-readable copies for downstream review tooling.
    files["state-inventory.json"] = json.dumps(
        {"trace": TRACE_ID, "entries": state_entries}, indent=2
    ) + "\n"
    files["override-ledger.json"] = json.dumps(
        {"trace": TRACE_ID, "overrides": audit_facts.get("overrides", [])}, indent=2
    ) + "\n"
    files["parity-matrix.json"] = json.dumps(
        {"trace": TRACE_ID, "assertions": parity.get("assertions", [])}, indent=2
    ) + "\n"
    files["pin-manifests.json"] = json.dumps(
        {"trace": TRACE_ID, "source": source_pins, "target": target_pins}, indent=2
    ) + "\n"

    for name, content in files.items():
        (output_dir / name).write_text(content, encoding="utf-8")
    return list(files)


def self_scan_package(diag, output_dir, emitted):
    """FC10 (output side): the emitted package must claim no acceptance."""
    for name in emitted:
        content = (output_dir / name).read_text(encoding="utf-8")
        match = ACCEPTANCE_CLAIM_RE.search(content)
        if match:
            diag.add(
                "acceptance-claim-prohibited",
                f"emitted package file '{name}' contains acceptance-status "
                f"token '{match.group(0)}'",
            )


def main():
    parser = argparse.ArgumentParser(
        description="Offline s-router-prod latest-pin migration "
                    "documentation module (no live acquisition)."
    )
    parser.add_argument("--input-dir", required=True)
    parser.add_argument("--output-dir", required=True)
    args = parser.parse_args()

    diag = Diagnostics()

    input_dir = Path(args.input_dir).resolve()
    output_dir = Path(args.output_dir).resolve()
    for label, directory in (("input", input_dir), ("output", output_dir)):
        for prefix in LIVE_PATH_PREFIXES:
            if str(directory) == prefix or str(directory).startswith(prefix + "/"):
                diag.add(
                    "live-surface-reference",
                    f"{label} directory '{directory}' is under live/runtime "
                    f"path prefix '{prefix}'",
                )
    diag.flush_and_maybe_exit()

    docs = load_inputs(diag, input_dir)
    diag.flush_and_maybe_exit()

    for name, doc in docs.items():
        check_live_surface(diag, name, doc)
        check_plaintext_secrets(diag, name, doc)
        check_acceptance_claims_in_inputs(diag, name, doc)
    check_pin_manifests(
        diag, docs["source-pins"], docs["target-pins"], docs["coherent-stack"]
    )
    check_durable_state(diag, docs["state-schema"])
    check_overrides(diag, docs["audit-facts"])
    check_rollback(diag, docs["migration-plan"])
    check_parity(diag, docs["parity-matrix"])
    check_semantic_deltas(diag, docs["audit-facts"])
    diag.flush_and_maybe_exit()

    emitted = emit_package(output_dir, docs, input_dir)
    self_scan_package(diag, output_dir, emitted)
    diag.flush_and_maybe_exit()

    print(f"{TRACE_ID}: emitted {len(emitted)} package files to {output_dir}")
    print("documentation/planning output only; no acceptance status asserted")


if __name__ == "__main__":
    main()
