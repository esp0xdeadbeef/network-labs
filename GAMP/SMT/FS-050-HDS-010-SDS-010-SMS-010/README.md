# FS-050-HDS-010-SDS-010-SMS-010 SMT

Row-local source stub for protected inventory boundary.

Construction-only — no active-lab mini-SMT runtime targets.
CMC code in `network-control-plane-model` commit `8c0cafd` implements the
protected-inventory boundary in `src/cpm/secret-source-contract.nix`.

Focused construction proof:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-050-HDS-010-SDS-010-SMS-010-protected-inventory-boundary.sh
```

The test proves redacted reference emission, SN1 unauthorized consumer
rejection, SN2 `plaintextMaterial=true` public-surface rejection, and
DNS/NAT/public exposure/trust non-authority. No live host, container, HAT, or
SAT evidence is claimed for this construction-only row.
