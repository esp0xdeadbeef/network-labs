# FS-800-HDS-010-SDS-020 SIT

Status: OK - focused source structure and live active-lab probes validate the
row-local provider-handoff default-route behavior.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-800-HDS-010-SDS-020-SMS-040`

Run the row-local source structure check:

```sh
bash tests/FS-800-HDS-010-SDS-020-SMS-040.sh
```

Run the canonical live entrypoint after staging this row on the isolated lab:

```sh
../network-codex-agent/scripts/live-FS-800-HDS-010-SDS-020-SMS-040.sh --live
```

Live row evidence on 2026-06-30:

- `provider-handoff-access-a` exists on the small row-local current-lab surface,
  not as a HAT-prefixed runtime target.
- The provider-handoff access node carries `203.0.113.1/24` and its default
  route uses the fabric gateway `10.80.255.2`, with no PPP interface present on
  that access node.
- The PPPoE-side core is a separate core node; its default route stays on the
  uplink interface `u0` and does not leak onto the fabric p2p interface.
- The test-client host remains a client-only surface for this row and must not
  deploy router containers.
