# FS-800-HDS-010-SDS-020-SMS-040 SMT

Row-local source for the mini provider-access default-route SMT.

Run:

```bash
bash tests/FS-800-HDS-010-SDS-020-SMS-040.sh
```

This row proves CPM provider-access fabric gateway routing: provider handoff to
internet with correct next-hop selection. The selectable mini topology uses the
minimal current compiler/NFM policy path plus a PPPoE core side link, and may
start at most 6 runtime targets.
