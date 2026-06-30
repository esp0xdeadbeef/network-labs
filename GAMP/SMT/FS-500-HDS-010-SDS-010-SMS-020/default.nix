{
  layer = "SMT";
  traceId = "FS-500-HDS-010-SDS-010-SMS-020";
  miniSmtId = "FS-500-HDS-010-SDS-010-SMS-020";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-500-HDS-010-SDS-010-SMS-020__mini-decision-type-client-to-testnet"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-020";
    focusedTest = null;
    maxRuntimeTargets = 2;
    scope = "NFM reachability decision type preservation: traffic-path answer records carry type identifiers, missing-type/wrong-type detection with diagnostics";
  };
}
