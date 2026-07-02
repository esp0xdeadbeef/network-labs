{
  layer = "SMT";
  traceId = "FS-350-HDS-010-SDS-010-SMS-050";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-350-HDS-010-SDS-010-SMS-050__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-control-plane-model";
    focusedTest = "tests/FS-350-HDS-010-SDS-010-SMS-050-fs350-inventory-realization-cross-ledger-diagnostics.sh";
    smtRow = "GAMP/SMT/README.md row 223";
    status = "OK";
    verifiedAt = "network-control-plane-model local HEAD (2026-07-02)";
    scope = "inventory realization cross-ledger diagnostics: realizes overlay participant-address assignments from NFM ledger into CPM inventory without changing overlay identity, emits E_OVERLAY_PARTICIPANT_CROSS_LEDGER_REALIZATION diagnostics, preserves distinction from delegated endpoint/tenant-prefix records (construction-only, CPM-owned)";
  };
}
