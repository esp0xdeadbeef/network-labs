{
  layer = "SMT";
  traceId = "FS-270-HDS-010-SDS-010-SMS-030";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
  };
  evidence = {
    owningRepo = "network-labs";
    focusedTest = "tests/test-gamp-row-source-stubs.sh";
    status = "NOT OK";
    scope = "Row-local SMT/SIT source stub exists so the SMS can be addressed by the controlled network-labs source tree.";
  };
}
