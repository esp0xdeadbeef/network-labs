{
  layer = "SMT";
  traceId = "FS-350-HDS-010-SDS-010-SMS-050";
  evidenceBoundary = "construction-only";
  source = {
    kind = "source-reference";
    intent = null;
    expectedRelationIds = null;
  };
  evidence = {
    owningRepo = "network-control-plane-model";
    focusedTest = "tests/test-fs350-inventory-realization-cross-ledger-diagnostics.sh";
    smtRow = "GAMP/SMT/README.md row 223";
    status = "OK";
    verifiedAt = "CPM HEAD (2026-06-05), re-verified 2026-06-27";
    scope = "inventory realization cross-ledger diagnostics: realizes overlay participant-address assignments from NFM ledger into CPM inventory without changing overlay identity, emits E_OVERLAY_PARTICIPANT_CROSS_LEDGER_REALIZATION diagnostics, preserves distinction from delegated endpoint/tenant-prefix records (construction-only, CPM-owned)";
  };
}
