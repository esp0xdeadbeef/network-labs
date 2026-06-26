# FS-100-HDS-010-SDS-010

SDS template row for emitter provenance and source identity mini POCs.

This row currently maps:

- `FS-100-HDS-010-SDS-010-SMS-010` for emitter repository provenance recording.
- `FS-100-HDS-010-SDS-010-SMS-020` for deterministic source identity.
- `FS-100-HDS-010-SDS-010-SMS-030` for signed-output source containment.
- `FS-100-HDS-010-SDS-010-SMS-040` for provenance redaction.
- `FS-100-HDS-010-SDS-010-SMS-050` for output artifact baseline binding.

SMS-010 is construction-only (compiler provenance recording) — no mini-SMT
runtime surface required. Remaining SMS traces have independent construction tests
in their owning repositories (network-compiler, network-codex-agent).
