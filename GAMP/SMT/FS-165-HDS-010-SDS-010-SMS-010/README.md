# FS-165-HDS-010-SDS-010-SMS-010

This row-local SMT anchor documents the construction test for source-value
necessity validation (FS-165-HDS-010-SDS-010-SMS-010).

## Test Location

The focused construction test lives in `network-codex-agent`:

```sh
bash tests/test-gamp-fs165-source-form-minimality.sh
```

The test exercises `scripts/helpers/gamp-sms-input-contracts.py` with inline
JSON fixtures covering all SMS-010 predicates, plus sibling SMS-020 (Readable
Normalized Source Form) and SMS-030 (Downstream Contract Gap Diagnostic).

## SMS Predicates Covered

- **MR1-MR4**: Source-class consumption, source-value acceptance/rejection,
  downstream-detail rejection, diagnostic emission
- **FC1-FC3**: No-allowed-class, duplicates-downstream-detail,
  creates-unmodeled-behavior-or-realization
- **SN1**: Source value duplicates downstream implementation detail (e.g.,
  `nftChainName: "POSTROUTING"` in userIntent → REJECTED with diagnostic)
- **SN2**: Source value has no allowed class → REJECTED with diagnostic

## Evidence Classification

This SMS is `construction-only` — all predicates are provable via static
source-level validation without runtime infrastructure.

## SIT Integration

The parent SIT row `GAMP/SIT/FS-165-HDS-010-SDS-010/` consumes this SMS input
together with sibling FS-165-HDS-010-SDS-010-SMS-020 and
FS-165-HDS-010-SDS-010-SMS-030 for source-form review integration.
