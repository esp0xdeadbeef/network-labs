# FS-390-HDS-010-SDS-010-SMS-020 SMT

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-020-public-ipv4-shortcut-policy.md`

Status: OK - runnable intent-source fixture.

This row proves that explicit service and public-ingress relations over modeled
public IPv4 addresses become forwarding-model shortcut authorizations. The
seeded missing-return negative is owned by the NFM construction test because the
compiler-input shape intentionally defaults ordinary allow relations to
`returnBehavior = "symmetric"`.

Title slug: `public-ipv4-shortcut-policy`

Focused source check:

```sh
GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-020/test.sh
```
