# FS-370-HDS-010-SDS-010 SIT

SIT row for the mini lane egress binding integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-370-HDS-010-SDS-010-SMS-050`

Run the small row input independently:

```sh
tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-050
```

Live closure also requires the row-specific active-lab verifier to pass on the
real `s-router-nixos`, `s-router-clab`, and `s-router-test-clients` surfaces.
The live verifier must prove the selected active-lab row is exactly the
five-target lane path, not the full HAT/SAT topology and not a two-node source
stub.
