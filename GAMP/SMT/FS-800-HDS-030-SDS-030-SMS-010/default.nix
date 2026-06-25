{
  layer = "SMT";
  traceId = "FS-800-HDS-030-SDS-030-SMS-010";
  miniSmtId = "pppoe-pairing";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-800-HDS-030-SDS-030-SMS-010__mini-pppoe-client-to-provider"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh pppoe-pairing";
    focusedTest = "tests/test-active-lab-mini-smt-pppoe-pairing-only.sh";
    maxRuntimeTargets = 2;
    scope = "PPPoE provider/customer pairing and fallback rejection";
  };
}
