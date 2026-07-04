# FS-040-HDS-010-SDS-010 SDS

Status: OK - active-lab evidence current 2026-07-04.

This row groups the public-inventory boundary SMS for active-lab execution.
The canonical design remains in `network-codex-agent`; this lab row records
the row-local source and live evidence boundary.

Current evidence, 2026-07-04:

- `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.sh`
  in `network-control-plane-model`.
- `GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/test.sh` in `network-labs`.
- `bash tests/test-smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh` in
  `network-codex-agent` at `5f1fb8fe`.
- Direct live verifier PASS:
  `/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T061645Z`.
- Active-lab runner PASS with offline verifier disabled:
  `/tmp/active-lab-mini-smt-runs/20260704T062015Z-2938737/FS-040-HDS-010-SDS-010-SMS-010`.
- Active-lab runner live verifier evidence:
  `/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T062022Z`.
- Manual runtime comparer PASS:
  `python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals`.

This is SDS/SMS/SMT/SIT evidence for the focused public-inventory boundary row.
It does not claim HAT, SAT, production readiness, or general client internet
reachability.
