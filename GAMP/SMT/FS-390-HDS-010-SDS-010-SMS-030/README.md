# FS-390-HDS-010-SDS-010-SMS-030 SMT

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-030-broad-wan-public-ipv4-denial.md`

Status: OK - runnable intent-source fixture.

This row proves that a broad-WAN allow does not authorize model-owned public IPv4
destinations. The intent uses compiler-owned `public-ipv4` targets so the NFM
receives explicit public destination addresses without inventing compiler or CPM
data in a renderer.

Title slug: `broad-wan-public-ipv4-denial`

Focused source check:

```sh
GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-030/test.sh
```
