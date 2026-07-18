# FS-540-HDS-010-SDS-010 SIT

Focused SIT row for the mini DNS resolver config integration path.

SIT rows are SDS-scoped, but the inputs are explicit SMS atoms. This row
currently consumes:

- `FS-540-HDS-010-SDS-010-SMS-020` — CPM DNS resolver configuration authority.
- `FS-540-HDS-010-SDS-010-SMS-040` — requester-lane recursive reachability,
  consumed here only at the construction-evidence boundary.
- `FS-540-HDS-010-SDS-010-SMS-045` — prod-like access recursive DNS from a real
  `s-router-test-clients` endpoint through the selector/core path.
- `FS-540-HDS-010-SDS-010-SMS-010` — recursive DNS binding source alignment,
  consumed here only as a row-local source stub.

Run the small row input independently:

```sh
tests/run-active-lab-mini-smt.sh FS-540-HDS-010-SDS-010-SMS-020
tests/run-active-lab-mini-smt.sh FS-540-HDS-010-SDS-010-SMS-045
```

Run the live recursive DNS SIT probe against the active lab:

```sh
S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab \
  tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh
../network-codex-agent/scripts/smt-live-FS-540-HDS-010-SDS-010-SMS-045.sh
```

The live probe must verify resolver-source artifacts, local recursive resolver
state, bounded DNS recursion from NixOS and CLAB runtime targets, real
test-client recursive DNS, resolver-identity route selection that distinguishes
upstream UDP/TCP destination-port-53 socket lookups from internal replies,
rejection of output-mark-only and process-wide UID selection, and absence of
Docker/host public resolver fallback on the CLAB core recursive path.
