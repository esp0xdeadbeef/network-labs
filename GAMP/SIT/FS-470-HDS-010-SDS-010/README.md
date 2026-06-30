# FS-470-HDS-010-SDS-010 SIT Integration

SIT integration container for FS-470-HDS-010-SDS-010 SMS-010 and sibling traces.

**Evidence Boundary:** active-lab mini SMT/SIT for SMS-010; construction-only
source for SMS-040.

Current focused command:

```sh
tests/run-active-lab-mini-smt.sh wireguard-remote-egress
```

The SMS-010 input is the row-local renderer-input CPM fixture
`GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix`.
It verifies WireGuard provider-runtime import and materialization surfaces for
one active-lab runtime target, not HAT/SAT acceptance.
