# FS-030-HDS-010-SDS-010-SMS-040 SMT

Row-local construction-only documentation anchor for the CPM binder source audit module.

**Trace**: FS-030-HDS-010-SDS-010-SMS-040
**Purpose**: Audit every CPM realization-binding output field for a binder source-class audit reference plus upstream behavior reference; reject fields with missing or cross-stage audit records before renderer handoff.

## Construction Evidence

The authoritative construction test lives in `network-control-plane-model`:
`tests/test-cpm-realization-binder-source-audit.sh`

Per the SMS Construction Handoff (GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-040-cpm-binder-source-audit.md):
- Proves every CPM realization-binding output carries binder source audit plus upstream behavior reference
- Proves missing or cross-stage audit records fail before renderer handoff

## SMS Predicates

- **MR**: Consume upstream behavior references and CPM binder source-class inputs, preserve audit reference for each realization-binding field, fail closed on missing binder + behavior references
- **FC**: Realization-binding field lacks binder source-class audit, lacks upstream behavior reference, CPM audit claims non-CPM authority
- **SN1**: Missing binder source-class audit reference → REJECTED with `CPM_BINDER_SOURCE_AUDIT_MISSING` diagnostic; recovery: adding audit reference passes upstream-behavior check
- **SN2**: Missing upstream behavior reference → REJECTED with `CPM_UPSTREAM_BEHAVIOR_REF_MISSING` diagnostic

## Evidence Boundary

Construction-only — all predicates are provable via unit tests in the CPM repo. No live host or runtime surface needed.

## Status

SMT row: NOT OK (evidence accepted but status not yet flipped; test exists and passes at HEAD per SMT evidence column).

This is SMT construction evidence only and does not promote SIT/HAT/SAT.
