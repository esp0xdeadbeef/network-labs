{
  layer = "SMT";
  traceId = "FS-350-HDS-010-SDS-010-SMS-030";
  evidenceBoundary = "construction-only";
  source = {
    kind = "source-reference";
    intent = null;
    expectedRelationIds = null;
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/test-fs350-overlay-ledger-construction.sh";
    smtRow = "GAMP/SMT/README.md row 221";
    status = "OK";
    verifiedAt = "NFM HEAD (2026-06-05), re-verified 2026-06-27";
    scope = "overlay participant ledger: segments overlay node IPAM by overlay identity, emits one participant-address ledger per overlay, rejects cross-ledger assignments with wrong-overlay-ledger diagnostics (construction-only, NFM-owned)";
  };
}
