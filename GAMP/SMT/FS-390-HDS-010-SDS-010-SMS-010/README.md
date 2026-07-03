# FS-390-HDS-010-SDS-010-SMS-010 SMT

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-010-public-ipv4-destination-classification.md`

Status: focused source and NFM construction check present; live row proof is
recorded by `network-codex-agent/scripts/smt-live-FS-390-HDS-010-SDS-010-SMS-010.sh`.

This row models public IPv4 destination ownership records for:

- enterprise-client ownership from `ownership.prefixes`
- tenant-service ownership from `communicationContract.services`
- public-ingress ownership from `communicationContract.services.publicIngress`
- locally owned routed endpoints from `ownership.endpoints`
- provider-owned endpoints from `ownership.endpoints`

The row-local construction check is:

```bash
GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-010/test.sh
```

The live script must validate the emitted `forwarding.json` classifier on the
real `s-router-nixos` and `s-router-clab` hosts before this row is considered
live executed.
