# FS-050-HDS-010-SDS-010

SDS template row for protected inventory boundary mini POCs.

This row currently maps:

- `FS-050-HDS-010-SDS-010-SMS-010` for protected inventory boundary (construction-only).

FS-050 is the protected-inventory sister of FS-040 (Public Inventory Boundary).
CMC implementation is in CPM `src/cpm/secret-source-contract.nix`. The dedicated
FS-050 construction test
`tests/FS-050-HDS-010-SDS-010-SMS-010-protected-inventory-boundary.sh` now
proves the clean protected-reference path plus seeded negatives for SN1
unauthorized consumer, SN2 plaintext leak, and protected inventory attempts to
create DNS/NAT/public exposure/trust policy.
