# FS-800-HDS-030-SDS-030 SIT

Focused SIT row for the mini PPPoE provider/customer pairing integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-800-HDS-030-SDS-030-SMS-010` — PPPoE provider/customer pairing and
  fallback rejection.
- `FS-800-HDS-030-SDS-030-SMS-040` — HAT script override rejection, consumed
  here only at the construction-evidence boundary.

Run the row-local source check:

```bash
tests/run-active-lab-mini-smt.sh pppoe-pairing
```

Run the live active-lab verifier after selecting and deploying this row:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 \
  S_ROUTER_NIXOS=192.168.1.17 \
  S_ROUTER_CLAB=192.168.1.19 \
  S_ROUTER_TEST_CLIENTS=192.168.1.18 \
  ../network-codex-agent/scripts/fs800-pppoe-pairing-active-lab-runtime-check.sh --live
```

The selected current-lab source must render exactly five router targets on
`s-router-nixos` and `s-router-clab`, and no router containers on
`s-router-test-clients`.
