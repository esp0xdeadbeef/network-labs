# FS-050-HDS-010-SDS-010-SMS-010 SMT

Row-local source stub for protected inventory boundary.

Construction-only — no active-lab mini-SMT runtime targets.
Existing CMC code in `network-control-plane-model` (`binder-source-audit.nix`)
handles protected-inventory source class. Dedicated RaTM test with FS-050-specific
seeded negatives (SN1 unauthorized consumer, SN2 plaintext leak) required.

SMT row 108: NOT OK (no dedicated test at HEAD).
