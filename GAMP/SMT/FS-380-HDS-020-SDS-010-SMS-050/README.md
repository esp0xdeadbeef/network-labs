# FS-380-HDS-020-SDS-010-SMS-050 SMT

Row-local source for the mini internet mode verification SMT.

Tests renderer internet mode record consumption from CPM output:
tenant client → external WAN with `privateNat44` source prefixes and output interfaces.

Run:

```bash
tests/run-active-lab-mini-smt.sh internet-mode-verification
```

This row starts `client-edge` and `wan-core` runtime targets.
SMS-050 is a coordinator; primary construction verification lives in sibling SMS-060.
