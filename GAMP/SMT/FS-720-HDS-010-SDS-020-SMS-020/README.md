# FS-720-HDS-010-SDS-020-SMS-020 SMT

Row-local source for the mini endpoint harness consumption SMT.

Tests the s-router-test-clients harness consumption of endpoint fixtures from
source-classified CPM endpointAssignment contracts. Proves that endpoint
fixtures are consumed only from SMS-010 source-classified records, not from
scripts, renderer defaults, or runtime discovery.

Status: OK - construction-only source stub. The owning proof is
`network-codex-agent@d7f20211`:
`NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-720-HDS-010-SDS-020-SMS-020.sh`
PASS at `/tmp/fs720-sds020-sms020-harness-consumption/run.cR20UO`.

This row is intentionally not registered in `GAMP/SMT/mini-smt/tests.nix`.
The source keeps `client-edge`, `printer-edge`, and `receiver-edge` logical
inputs addressable for construction proof only; it is not active-lab mini
runtime evidence and does not claim HAT/SAT acceptance.
