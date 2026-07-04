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

`FS-100-HDS-010-SDS-010-SMS-010` was re-verified on 2026-07-04 through
`tests/run-active-lab-mini-smt.sh FS-100-HDS-010-SDS-010-SMS-010`. The active
lab selected it as construction-only with zero runtime targets; this SIT input
therefore contributes emitter-provenance construction evidence only.

`FS-100-HDS-010-SDS-010-SMS-020` is likewise construction-only: it contributes
deterministic source identity evidence from the compiler provenance module and
does not create router runtime targets. The current focused compiler proof
passed at `network-compiler` HEAD `19d66ef` on 2026-07-04.

`FS-100-HDS-010-SDS-010-SMS-030` is also construction-only: it contributes
signed-output source containment evidence from the compiler provenance module
and does not create router runtime targets. The current focused compiler proof
passed at `network-compiler` HEAD `878f54c` on 2026-07-04.
