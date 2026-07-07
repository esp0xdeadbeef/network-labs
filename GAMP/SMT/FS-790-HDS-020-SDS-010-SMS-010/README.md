# SMT Source: FS-790-HDS-020-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-790-HDS-020-SDS-010-SMS-010-public-ingress-row-atomization.md`

Status: OK - SMT construction evidence proven.

Focused construction test `tests/test-FS-790-HDS-020-SDS-010-SMS-010-public-ingress-row-atomization.sh` validates:
- 6 fixture rows atomized (2 per site: tcp + udp)
- Each row has single publicSurface, protocol, publicPort, targetService,
  targetEndpoint, targetPort, returnPath
- Every row emits denied-variant records
- Every row requires external provider
- Every row references explicit public-exposure policy
- Seeded negative: multi-leg row rejected
- Seeded negative: provider-binding-without-policy rejected

Evidence boundary: construction-only. No live host required.
