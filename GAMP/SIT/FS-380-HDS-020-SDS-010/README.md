# FS-380-HDS-020-SDS-010 SIT

SIT row stub for the mini internet mode verification integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-380-HDS-020-SDS-010-SMS-050`
- `FS-380-HDS-020-SDS-010-SMS-120`

Run the small row input independently:

```sh
tests/run-active-lab-mini-smt.sh FS-380-HDS-020-SDS-010-SMS-050
tests/run-active-lab-mini-smt.sh FS-380-HDS-020-SDS-010-SMS-120
```
