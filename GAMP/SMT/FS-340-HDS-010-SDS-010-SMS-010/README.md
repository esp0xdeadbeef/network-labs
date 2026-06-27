# FS-340-HDS-010-SDS-010-SMS-010 SMT

Row-local source for IPv4 Decimal Offset Parsing Software Module Specification.

**Validation Evidence Boundary:** construction-only — all predicates are provable with construction tests against compile-time CPM output. No live host/runtime surface required.

## SMS Predicates

- **Module Responsibilities:** Parse IPv4 offsets as decimal host-position values inside modeled IPv4 subnet. Reject non-decimal syntax.
- **Seeded Negative 1 (SN1):** Non-decimal IPv4 offset `0x0A` (hex) → `diagnostic.nonDecimalOffset` naming violating value.
- **Seeded Negative 2 (SN2):** Offset `300` exceeds subnet host range `/24` max 254 → `diagnostic.offsetOutOfRange` naming offset, subnet, max valid offset.

## Construction Evidence

- Repo: `network-control-plane-model`
- Test: `tests/FS-970-HDS-010-SDS-010-SMS-020-static-reservation-offset-resolution.sh`
- Commit: `c0e9ee1`
- Verified by: sms-specialist-042 (2026-06-17)
- Status: PASS — proves `requireInt` gate rejects non-integer offsets, `ipam.allocOne` enforces out-of-prefix rejection. Nix parser auto-normalizes `0x0A` to integer 10 (constraint not CMC gap).

## Sibling Traces

- FS-340-HDS-010-SDS-010-SMS-020: IPv6 Hex Offset Parsing
- FS-340-HDS-010-SDS-010-SMS-030: Offset Boundary Validation
- FS-340-HDS-010-SDS-010-SMS-040: Duplicate Offset Validation
