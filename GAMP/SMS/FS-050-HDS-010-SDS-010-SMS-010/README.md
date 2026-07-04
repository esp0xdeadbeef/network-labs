# FS-050-HDS-010-SDS-010-SMS-010

SMS template row for protected inventory boundary.

This SMS governs CPM protected-inventory source class handling: consuming protected
inventory references, binding protected values only to authorized modeled consumers,
emitting redacted references, and rejecting unauthorized/missing/plaintext-leaking
data.

CMC code exists in
`network-control-plane-model/src/cpm/secret-source-contract.nix`.

Current construction evidence is OK at
`network-control-plane-model` commit
`eade1c264d61db68d02aa8ade64b9ddfe975c4fd` via:

```bash
NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-050-HDS-010-SDS-010-SMS-010-protected-inventory-boundary.sh
```

The construction test carries the full trace ID and proves the clean redacted
protected reference path plus seeded negatives for unauthorized public
diagnostics consumption, plaintext material leakage, and protected inventory
attempts to create DNS/NAT/public exposure/trust policy.
