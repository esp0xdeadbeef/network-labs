# FS-370-HDS-010-SDS-010 SIT

SIT row for the mini lane egress binding integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-370-HDS-010-SDS-010-SMS-040` as construction-only unrelated route denial input
- `FS-370-HDS-010-SDS-010-SMS-050`
- `FS-370-HDS-010-SDS-010-SMS-101` as source-stub-only return-path input

Run the small row input independently:

```sh
tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-050
```

Live closure also requires the row-specific active-lab verifier to pass on the
real `s-router-nixos`, `s-router-clab`, and `s-router-test-clients` surfaces.
The live verifier must prove the selected active-lab row is exactly the
five-target lane path, not the full HAT/SAT topology and not a two-node source
stub.

Current live status: NOT OK on 2026-07-02. The row-local source and CPM checks
pass after removing the duplicate `testnet` bridgeNetwork from the FS-370
mini-SMT inventories, but live closure is pending because `s-router-nixos` is
unreachable and the reachable `s-router-clab` and `s-router-test-clients`
artifacts are not selected to this FS-370 row. Current live failure is
preserved in `network-codex-agent/tests/observed-runtime-failures/` as
`test-20260702T181948Z-fs370-active-lab-live-stale-unreachable.sh` with its
full log in the adjacent `logs/` directory.
