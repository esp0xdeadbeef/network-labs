{
  layer = "SMT";
  traceId = "FS-200-HDS-010-SDS-010-SMS-010";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-200-HDS-010-SDS-010-SMS-010__mini-client-to-testnet"
    ];
  };
  evidence = {
    scope = "structural validation: two-node topology with one tenant-to-external allow relation, verifies intent fixture parses and topology is well-formed";
  };
  sharedFiles = {
    miniSmtDefaultNix = "NOT EDITED — row-local files only per GAMP/SMT/README.md shared-file policy";
    miniSmtTestsNix = "NOT EDITED — row-local files only";
    testsTestSh = "NOT EDITED — standalone focused test, not in manifest";
  };
}
