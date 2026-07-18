# FS-540-HDS-010-SDS-010-SMS-020 SMT

Row-local source for the CPM DNS resolver configuration authority mini SMT.

The revised row must test normalized CPM resolver authority: provider-side
terminal listeners and matching access forwarders, explicit recursion mode and
egress selection, requester ACLs, forwarding-compatible local namespace mode,
and stable redacted warnings. The old per-interface `dns.resolver4`,
`dns.resolver6`, and `dns.resolverSource` predicates alone are insufficient.

Run:

```bash
tests/run-active-lab-mini-smt.sh --source FS-540-HDS-010-SDS-010-SMS-020
tests/run-active-lab-mini-smt.sh FS-540-HDS-010-SDS-010-SMS-020
```

This row's live SIT selection starts only the smallest DNS policy path:
`access-dns`, `downstream-selector`, `policy`, `upstream-selector`, and
`resolver-node`. It must not select the full active-lab, HAT, or SAT topology.

Live SIT recursion is checked separately because the mini-SMT is construction
scope:

```bash
S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab \
  tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh
```

This is construction evidence for the SMS row only. The parent SIT row
`GAMP/SIT/FS-540-HDS-010-SDS-010/default.nix` consumes this SMS input.

Status: NOT OK until both the endpoint-path mismatch and namespace-shadow
seeded negatives pass in the owning CPM tests.
