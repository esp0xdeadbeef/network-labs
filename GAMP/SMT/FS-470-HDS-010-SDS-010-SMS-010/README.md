# SMT Source Stub: FS-470-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-010-wireguard-remote-egress.md`

Status: OK - focused active-lab mini SMT/SIT source is registered.

This row now owns the row-local renderer-input CPM fixture at
`renderer-input/wireguard-remote-egress-cpm.nix`. The focused runner is
`tests/test-active-lab-mini-smt-wireguard-remote-egress-only.sh` via:

```sh
tests/run-active-lab-mini-smt.sh FS-470-HDS-010-SDS-010-SMS-010
```

The fixture starts one runtime target, `wireguard-remote-egress`, and carries
the explicit `controlPlane.providerContracts.wireguard.wg-remote-egress`
provider runtime contract consumed by `network-renderer-wireguard.hostModule`.
This is SMT/SIT mini runtime evidence only; it is not HAT/SAT approval.

Title slug: `wireguard-remote-egress`
