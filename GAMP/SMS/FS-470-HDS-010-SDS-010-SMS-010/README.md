# SMS Mirror: FS-470-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-010-wireguard-remote-egress.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: Active-lab mini SMT/SIT source registered.

The row-specific source is
`GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix`.
It carries one `wireguard-remote-egress` runtime target and the explicit
`controlPlane.providerContracts.wireguard.wg-remote-egress` provider runtime
contract used by the WireGuard renderer host module.

Focused source/integration command:

```sh
tests/run-active-lab-mini-smt.sh FS-470-HDS-010-SDS-010-SMS-010
```

This is row-local SMT/SIT evidence only. HAT/SAT remain separate validation
boundaries.
