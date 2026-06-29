# FS-165-HDS-010-SDS-010 SIT

SIT row for the source-form review pipeline (FS-165).

## SMS Inputs

This SIT row consumes three SMS atoms that collectively implement the
source-form review stage defined by SDS FS-165-HDS-010-SDS-010:

| SMS | Role | Construction Test |
| --- | --- | --- |
| FS-165-HDS-010-SDS-010-SMS-010 | Source-Value Necessity | `tests/test-fs165-hds010-sds010-sms010-source-value-necessity.sh` |
| FS-165-HDS-010-SDS-010-SMS-020 | Readable Normalized Source Form | `tests/test-fs165-hds010-sds010-sms010-source-value-necessity.sh` |
| FS-165-HDS-010-SDS-010-SMS-030 | Downstream Contract Gap Diagnostic | `tests/test-fs165-hds010-sds010-sms010-source-value-necessity.sh` |

## Integration Path

All three SMS modules are exercised by a row-local construction test in
`network-labs`: `bash tests/test-fs165-hds010-sds010-sms010-source-value-necessity.sh`.

The test uses the Python checker
`network-codex-agent/scripts/helpers/gamp-sms-input-contracts.py` with inline
JSON fixtures covering predicates across all three SMS specs.

## Evidence Boundary

This is construction-only integration evidence. The source-form review stage
operates at the model-input boundary and does not require runtime
infrastructure.
