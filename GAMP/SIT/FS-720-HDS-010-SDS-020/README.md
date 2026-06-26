# FS-720-HDS-010-SDS-020 SIT

SIT row stub for the mini endpoint harness consumption integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-720-HDS-010-SDS-020-SMS-020`

Run the small row input independently:

```sh
tests/run-active-lab-mini-smt.sh endpoint-harness-consumption
```
