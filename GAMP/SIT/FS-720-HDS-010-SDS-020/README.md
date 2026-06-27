# FS-720-HDS-010-SDS-020 SIT

SIT row stub for the endpoint harness consumption integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently keeps these prepared SMS inputs visible:

- `FS-720-HDS-010-SDS-020-SMS-020`
- `FS-720-HDS-010-SDS-020-SMS-040`

Status: NOT OK - prepared source only. `endpoint-harness-consumption` is not
registered in `GAMP/SMT/mini-smt/tests.nix`, and no executable focused mini-SMT
script exists yet.
