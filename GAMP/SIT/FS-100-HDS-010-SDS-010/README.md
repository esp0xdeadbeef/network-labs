# FS-100-HDS-010-SDS-010 SIT

SIT row stub for the emitter provenance and source identity integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-100-HDS-010-SDS-010-SMS-010` — emitter provenance (construction-only)
- `FS-100-HDS-010-SDS-010-SMS-020` — deterministic source identity
- `FS-100-HDS-010-SDS-010-SMS-030` — signed-output source containment
- `FS-100-HDS-010-SDS-010-SMS-040` — provenance redaction
- `FS-100-HDS-010-SDS-010-SMS-050` — output artifact baseline binding

All five SMS traces have independent SMT construction evidence in their
owning repositories. SIT integration would consume them as a group for
end-to-end provenance chain verification.
