# FS-380-HDS-020-SDS-010-SMS-050 SMT

Row-local source for the mini internet mode verification SMT.

Tests the SMT/SIT-only internet-mode source fixture: tenant client -> emulated
PPPoE provider -> emulated ISP upstream. The emulated ISP receives internet only
from the semantic `isp` and `pppoe-provider` uplinks. The row-local inventories
realize those uplinks as VLAN4/VLAN5 DHCP links. Skipping internet coverage,
NAT, and VLAN2 are rejected for this mini-lab source.

Run:

```bash
tests/run-active-lab-mini-smt.sh FS-380-HDS-020-SDS-010-SMS-050
```

This row is limited to `client-edge` and `emulated-isp` runtime targets.
The row-local inventories carry only the mini-SMT source facts required by the
test: emulated PPPoE handoff and VLAN4/VLAN5 DHCP upstreams.
