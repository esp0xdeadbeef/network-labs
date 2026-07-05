# SMT Row: FS-230-HDS-010-SDS-010-SMS-020

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-020-public-ingress-translation-binding.md`

Status: OK — construction complete.

Focused construction test `tests/test-fs230-hds010-sds010-sms020-public-ingress-translation-binding.sh`
validates that every public-ingress fixture row using translation binds explicit
translationMode, sourcePreservation, and asymmetricRouting per FS-230 and SMS-020.
Seeded negatives SN1 (ambiguous translation mode) and SN2 (hairpin without explicit
binding) fail closed with correct diagnostics.

Title slug: `public-ingress-translation-binding`
