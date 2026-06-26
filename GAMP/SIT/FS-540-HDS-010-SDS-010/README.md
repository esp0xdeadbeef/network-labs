# FS-540-HDS-010-SDS-010 SIT

SIT row stub for the mini DNS resolver config integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-540-HDS-010-SDS-010-SMS-020`

Run the small row input independently:

```sh
tests/run-active-lab-mini-smt.sh dns-resolver-config
```
