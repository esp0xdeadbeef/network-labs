{
  layer = "SMT";
  traceId = "FS-320-HDS-010-SDS-010-SMS-010";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-320-HDS-010-SDS-010-SMS-010__mini-client-to-testnet-allow"
      "FS-320-HDS-010-SDS-010-SMS-010__mini-mgmt-deny-internet"
    ];
  };
  evidence = {
    scope = "structural validation: two-node co-located topology with client+mgmt tenants, distinct allow/deny policy boundary, 10 predicates";
  };
  sharedFiles = {
    miniSmtDefaultNix = "NOT EDITED — row-local files only per GAMP/SMT/README.md shared-file policy";
    miniSmtTestsNix = "NOT EDITED — row-local files only";
    testsTestSh = "NOT EDITED — standalone focused test, not in manifest";
  };
}
