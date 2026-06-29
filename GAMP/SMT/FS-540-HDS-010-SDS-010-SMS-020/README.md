# FS-540-HDS-010-SDS-010-SMS-020 SMT

Row-local source for the CPM DNS resolver configuration authority mini SMT.

Tests CPM per-interface DNS resolver configuration emission:
`dns.resolver4`, `dns.resolver6`, and `dns.resolverSource` fields on interface
records, with correct recursive chain position scoping and self-referential
resolver prevention.

Run:

```bash
tests/run-active-lab-mini-smt.sh --source dns-resolver-config
tests/run-active-lab-mini-smt.sh dns-resolver-config
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
