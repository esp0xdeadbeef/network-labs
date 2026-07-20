# FS-340-HDS-010-SDS-010-SMS-010 SMS Template

Template row for IPv4 Decimal Offset Parsing SMS.

## Purpose

Defines the module contract for parsing IPv4 offsets as decimal host-position values inside modeled IPv4 subnets. Rejects non-decimal syntax and out-of-range offsets.

## Key Predicates

| Predicate | Description |
|-----------|-------------|
| MR1 | Parse IPv4 offsets only as decimal host-position values |
| MR2 | Reject non-decimal syntax with diagnostic |
| FC1 | Missing/ambiguous offset syntax → fail |
| FC2 | Offset not associated with IPv4 subnet + assignment scope → fail |
| SN1 | Hex offset `0x0A` → `diagnostic.nonDecimalOffset` |
| SN2 | Offset `300` in `/24` → `diagnostic.offsetOutOfRange` |

## Evidence Boundary

`construction-only` — all predicates provable with construction tests against CPM compile-time output (`network-control-plane-model`). No live host/runtime surface required.

## Construction Test

- Repo: `network-control-plane-model`
- Test: `tests/FS-970-HDS-010-SDS-010-SMS-020.sh`
- Verified: sms-specialist-042 (2026-06-17)
