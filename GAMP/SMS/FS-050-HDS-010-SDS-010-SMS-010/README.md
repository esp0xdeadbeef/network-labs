# FS-050-HDS-010-SDS-010-SMS-010

SMS template row for protected inventory boundary.

This SMS governs CPM protected-inventory source class handling: consuming protected
inventory references, binding protected values only to authorized modeled consumers,
emitting redacted references, and rejecting unauthorized/missing/plaintext-leaking
data.

CMC code exists in `network-control-plane-model/src/cpm/binder-source-audit.nix`
(shared with FS-040 public-inventory). No dedicated construction test carries
this trace-chain ID at CPM HEAD — RaTM gap. SMT row 108: NOT OK.
