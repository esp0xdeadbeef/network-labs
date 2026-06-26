# FS-050-HDS-010-SDS-010

SDS template row for protected inventory boundary mini POCs.

This row currently maps:

- `FS-050-HDS-010-SDS-010-SMS-010` for protected inventory boundary (construction-only).

FS-050 is the protected-inventory sister of FS-040 (Public Inventory Boundary).
CMC implementation is shared in CPM `binder-source-audit.nix`. Dedicated RaTM
test with FS-050 seeded negatives (SN1 unauthorized consumer, SN2 plaintext leak)
required.
