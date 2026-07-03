# FS-030-HDS-010-SDS-010-SMS-030 SMT

Row-local mini-SMT source for the compiler behavior source audit module.

**Trace**: FS-030-HDS-010-SDS-010-SMS-030
**Purpose**: Audit every compiler behavior-creating output field for a user-intent source-class reference; reject fields with missing, non-intent, or conflicting audit references.

## Construction Evidence

The authoritative construction test lives in `network-compiler`:
`tests/test-FS-030-HDS-010-SDS-010-SMS-030.sh`

Per the SMS Construction Handoff (GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-030-compiler-behavior-source-audit.md):
1. Iterates over all behavior-creating compiler output fields, asserts each carries `sourceClass: "user-intent"`
2. Constructs compiler output with `sourceClass: "realization"` or `"inventory"` on a behavior-creating field → rejected with diagnostics
3. Constructs compiler output with NO `sourceClass` on a behavior-creating field → fails-closed

## SMS Predicates

- **MR**: Consume compiler classification ledger, preserve audit reference for behavior-creating fields (tenant, service, trust-boundary, policy, exposure, translation, prefix-authority, persistence, routing), fail closed on missing audit reference
- **FC**: Behavior-creating field lacks user-intent sourceClass, audit reference claims non-compiler authority, output emitted after audit rejection
- **SN**: Set `sourceClass: "realization"` on tenant subnet allocation field → audit rejects with diagnostic naming field path and disallowed class; revert to `"user-intent"` → audit passes

## Evidence Boundary

Construction plus active-lab artifact proof. The compiler predicates are proved
by focused construction tests in the compiler repo; the active-lab wrapper
checks pinned nixos/clab artifacts carry this full trace and the expected
runtime-target shape.

## Status

SMT row: OK.

This is SMT construction evidence only and does not promote SIT/HAT/SAT.
