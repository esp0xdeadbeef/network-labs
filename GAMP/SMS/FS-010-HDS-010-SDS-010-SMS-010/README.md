# SMS Mirror: FS-010-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-010-HDS-010-SDS-010-SMS-010-accepted-source-set.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: Mirrored with active-lab mini-SMT construction evidence.

The canonical SMS title slug is `accepted-source-set`.

Focused evidence:

- 2026-07-03: `tests/test-active-lab-mini-smt-fs010-accepted-source-set.sh`
  runs the canonical `network-codex-agent/tests/test-gamp-sms-input-contracts.sh`
  source-set construction check and verifies that this row's active-lab intent
  exposes `FS-010-HDS-010-SDS-010-SMS-010__mini-verify`.

This is SMT construction/source-set evidence only. It does not claim HAT/SAT
runtime behavior or internet-routing validation.
