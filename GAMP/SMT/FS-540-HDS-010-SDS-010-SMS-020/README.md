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

This row starts `access-dns` and `resolver-node` runtime targets.

This is construction evidence for the SMS row only. The parent SIT row
`GAMP/SIT/FS-540-HDS-010-SDS-010/default.nix` consumes this SMS input.
