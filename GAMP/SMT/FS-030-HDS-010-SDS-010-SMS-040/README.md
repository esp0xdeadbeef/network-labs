# SMT Mini Source: FS-030-HDS-010-SDS-010-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-040-cpm-binder-source-audit.md`

Status: OK - active-lab mini-SMT runtime evidence.

Row-local source for the mini CPM binder source audit SMT.

**Trace**: FS-030-HDS-010-SDS-010-SMS-040
**Purpose**: Audit every CPM realization-binding output field for a binder source-class audit reference plus upstream behavior reference; reject fields with missing or cross-stage audit records before renderer handoff.

## Construction Evidence

The authoritative construction test lives in `network-control-plane-model`:
`tests/FS-030-HDS-010-SDS-010-SMS-020.sh`

Per the SMS Construction Handoff (GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-040-cpm-binder-source-audit.md):
- Proves every CPM realization-binding output carries binder source audit plus upstream behavior reference
- Proves missing or cross-stage audit records fail before renderer handoff

## SMS Predicates

- **MR**: Consume upstream behavior references and CPM binder source-class inputs, preserve audit reference for each realization-binding field, fail closed on missing binder + behavior references
- **FC**: Realization-binding field lacks binder source-class audit, lacks upstream behavior reference, CPM audit claims non-CPM authority
- **SN1**: Missing binder source-class audit reference → REJECTED with `CPM_BINDER_SOURCE_AUDIT_MISSING` diagnostic; recovery: adding audit reference passes upstream-behavior check
- **SN2**: Missing upstream behavior reference → REJECTED with `CPM_UPSTREAM_BEHAVIOR_REF_MISSING` diagnostic

This row provides a small intent-source fixture that exercises the CPM pipeline
for binder source audit testing: one tenant-to-external allow relation through
access -> external stages.

## 2026-07-04 Verification

- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-040` passed.
- `NETWORK_REPO_DIRECT_TEST_OK=1 bash ../network-control-plane-model/tests/FS-030-HDS-010-SDS-010-SMS-020.sh` passed inside the live wrapper, proving missing binder source audit, missing upstream behavior reference, and cross-stage authority seeded negatives fail closed.
- `../network-codex-agent/scripts/live-FS-030-HDS-010-SDS-010-SMS-040.sh` passed on `s-router-nixos`, `s-router-clab`, and `s-router-test-clients`.
- Evidence directory:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-010-SMS-040/20260704T042319Z`.
- Runtime target counts were `s-router-nixos=5`, `s-router-clab=5`, and
  `s-router-test-clients=0`.

This is SMT active-lab child-row evidence only and does not promote HAT/SAT or
production readiness.

Title slug: `cpm-binder-source-audit`
