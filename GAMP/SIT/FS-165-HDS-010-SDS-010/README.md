# FS-165-HDS-010-SDS-010 SIT

SIT row for the source-form review pipeline (FS-165).

## SMS Inputs

This SIT row consumes three SMS atoms that collectively implement the
source-form review stage defined by SDS FS-165-HDS-010-SDS-010:

| SMS | Role | Construction Test |
| --- | --- | --- |
| FS-165-HDS-010-SDS-010-SMS-010 | Source-Value Necessity | `tests/test-gamp-fs165-source-form-minimality.sh` |
| FS-165-HDS-010-SDS-010-SMS-020 | Readable Normalized Source Form | (shared test) |
| FS-165-HDS-010-SDS-010-SMS-030 | Downstream Contract Gap Diagnostic | (shared test) |

## Integration Path

All three SMS modules are exercised by a shared construction test in
`network-codex-agent`: `bash tests/test-gamp-fs165-source-form-minimality.sh`.

The test uses the Python checker `scripts/helpers/gamp-sms-input-contracts.py`
with inline JSON fixtures covering all predicates across all three SMS specs.

## Evidence Boundary

This is construction-only integration evidence. The source-form review stage
operates at the model-input boundary and does not require runtime
infrastructure.
