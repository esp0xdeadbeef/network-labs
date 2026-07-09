{
  layer = "SMT";
  traceId = "FS-800-HDS-010-SDS-020-SMS-030";
  miniSmtId = "FS-800-HDS-010-SDS-020-SMS-030";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-800-HDS-010-SDS-020-SMS-030__mini-provider-egress"
      "FS-800-HDS-010-SDS-020-SMS-030__mini-customer-nat"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-800-HDS-010-SDS-020-SMS-030";
    focusedTest = "tests/test-s-sigma-pppoe-pairing-fallback-rejection.sh";
    maxRuntimeTargets = 5;
    scope = "PPPoE pairing and fallback rejection";
  };
}
