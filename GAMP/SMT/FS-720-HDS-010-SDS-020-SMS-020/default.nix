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
    command = "tests/run-active-lab-mini-smt.sh endpoint-harness-consumption";
    focusedTest = "tests/test-active-lab-mini-smt-endpoint-harness-consumption-only.sh";
    maxRuntimeTargets = 3;
    scope = "s-router-test-clients endpoint harness consumption: validates endpoint fixtures consumed from source-classified records, rejects script-local/placeholder materialization";
  };
}
