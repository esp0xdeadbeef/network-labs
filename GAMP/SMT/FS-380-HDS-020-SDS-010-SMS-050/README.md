# FS-380-HDS-020-SDS-010-SMS-050 SMT

Row-local source for the mini internet mode verification SMT.

Tests the SMT/SIT-only internet-mode source fixture: tenant client -> emulated
PPPoE provider -> emulated ISP upstream. The emulated ISP receives internet only
from VLAN4/VLAN5 DHCP uplinks. Skipping internet coverage, NAT, and VLAN2 are
rejected for this mini-lab source.

Run:

```bash
tests/run-active-lab-mini-smt.sh internet-mode-verification
```

This row starts `client-edge` and `wan-core` runtime targets.
SMS-050 is a coordinator; primary construction verification lives in sibling SMS-060.
