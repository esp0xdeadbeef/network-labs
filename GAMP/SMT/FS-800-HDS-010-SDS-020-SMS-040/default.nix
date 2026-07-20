{
  layer = "SMT";
  traceId = "FS-800-HDS-010-SDS-020-SMS-040";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet"
    ];
  };
  evidence = {
    scope = "CPM provider-access fabric gateway routing contract — construction-provable predicates (MR1-MR4, FC1-FC5, SN1-SN2)";
  };
  sharedFiles = {
    miniSmtDefaultNix = "NOT EDITED — row-local files only per GAMP/SMT/README.md shared-file policy";
    miniSmtTestsNix = "NOT EDITED — row-local files only";
    testsTestSh = "NOT EDITED — standalone focused test, not in manifest";
    activeLabIntent = "NOT EDITED — row-local intent only";
  };
  policy = {
    rowLocalOnly = true;
    note = "Self-contained intent fixture; no import from shared mini-smt/ directories. Focused test runs nix eval against row-local intent.nix directly.";
  };
}
