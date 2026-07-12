# FS-500-HDS-010-SDS-010-SMS-050 SMT

Row-local mini-SMT for runtime point-to-point bridge co-location.

This is a construction-only row. Focused tests live in the owning renderer repos:
- `network-renderer-nixos`: NixOS host bridge co-location proof
- `network-renderer-containerlab-linux-backend`: CLAB link co-location proof

Run:
```bash
tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-050
```

The mini-SMT wrapper delegates to the renderer-focused construction tests
and verifies the SMS predicate coverage matrix.
