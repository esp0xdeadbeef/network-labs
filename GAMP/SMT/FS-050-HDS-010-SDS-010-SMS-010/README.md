# FS-050-HDS-010-SDS-010-SMS-010 SMT

Row-local source stub for protected inventory boundary.

Construction-only — no active-lab mini-SMT runtime targets.
CMC code in `network-control-plane-model` commit
`eade1c264d61db68d02aa8ade64b9ddfe975c4fd` implements the protected-inventory
boundary in `src/cpm/secret-source-contract.nix`.

Focused construction proof:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-050-HDS-010-SDS-010-SMS-010-protected-inventory-boundary.sh
```

The test proves redacted reference emission, SN1 unauthorized consumer
rejection, SN2 `plaintextMaterial=true` public-surface rejection, and
DNS/NAT/public exposure/trust non-authority. No live host, container, HAT, or
SAT acceptance is claimed for this construction-only row.

Current evidence:

- `network-control-plane-model/tests/FS-050-HDS-010-SDS-010-SMS-010-protected-inventory-boundary.sh`
  PASS with `NETWORK_REPO_DIRECT_TEST_OK=1`.
- `network-codex-agent/scripts/smt-live-FS-050-HDS-010-SDS-010-SMS-010.sh`
  PASS at `5944213f1687f26cc16d2c68746153b0aefd5d50`.
- Direct construction-wrapper evidence:
  `/tmp/s-router-live-smoke/FS-050-HDS-010-SDS-010-SMS-010/20260704T065003Z`.
- Active-lab runner evidence:
  `/tmp/active-lab-mini-smt-runs/20260704T065003Z-2975054/FS-050-HDS-010-SDS-010-SMS-010`.
- Active-lab runner wrapper evidence:
  `/tmp/s-router-live-smoke/FS-050-HDS-010-SDS-010-SMS-010/20260704T065006Z`.
- Pinned `nixos` builds PASS at lock commit `7fb9744b` with `network-labs`
  locked to `052dd0b60994788f3d3aa518c403a9b94f209762` for
  `s-router-nixos`, `s-router-clab`, and `s-router-test-clients`.

The live wrapper recorded context-only artifacts on `s-router-nixos`,
`s-router-clab`, and `s-router-test-clients` with `runtimeTargetCount=0` and
`traceHits=2`. Those artifacts prove the selected construction-only trace is
visible on the hosts; they are not runtime acceptance evidence.
