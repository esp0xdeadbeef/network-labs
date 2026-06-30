{
  layer = "SMT";
  traceId = "FS-500-HDS-010-SDS-010-SMS-010";
  miniSmtId = "FS-500-HDS-010-SDS-010-SMS-010";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-500-HDS-010-SDS-010-SMS-010__mini-allow-client-to-testnet"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-010";
    focusedTest = "tests/test-active-lab-mini-smt-reachability-decision-only.sh";
    maxRuntimeTargets = 5;
    scope = "one reachability decision relation and structured allow/deny classification over the five-node client -> downstream-selector -> policy -> upstream-selector -> testnet path";
  };
}
