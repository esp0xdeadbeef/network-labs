# FS-500-HDS-010-SDS-010-SMS-010

This row-local SMT input proves only the reachability decision result atom. It
uses `intent.nix` as a tiny active-lab source with one client-to-testnet
relation and no full active-lab, HAT, SAT, or aggregate renderer dependency.

Run:

```sh
tests/run-active-lab-mini-smt.sh --source reachability-decision
tests/run-active-lab-mini-smt.sh reachability-decision
```

This is construction evidence for the SMS row only. The parent SIT row
`GAMP/SIT/FS-500-HDS-010-SDS-010/default.nix` consumes this SMS input together
with the sibling `FS-500-HDS-010-SDS-010-SMS-040` p2p next-hop input.
