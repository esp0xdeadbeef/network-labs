{
  layer = "SMT";
  traceId = "FS-720-HDS-010-SDS-020-SMS-020";
  miniSmtId = "endpoint-harness-consumption";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-720-HDS-010-SDS-020-SMS-020__mini-client-harness-consumption"
    ];
  };
  evidence = {
    command = null;
    focusedTest = null;
    maxRuntimeTargets = 3;
    status = "NOT OK";
    missing = "endpoint-harness-consumption is not registered in GAMP/SMT/mini-smt/tests.nix and no executable focused mini-SMT script exists yet";
    scope = "Prepared source fixture for s-router-test-clients endpoint harness consumption; not an active runner shim until the manifest and focused test are added.";
  };
}
