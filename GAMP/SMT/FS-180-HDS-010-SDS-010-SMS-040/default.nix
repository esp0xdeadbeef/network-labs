{
  layer = "SMT";
  traceId = "FS-180-HDS-010-SDS-010-SMS-040";
  miniSmtId = "bidirectional-nft";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-180-HDS-010-SDS-010-SMS-040__mini-bidirectional-web"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh bidirectional-nft";
    focusedTest = "tests/test-active-lab-mini-smt-bidirectional-nft-only.sh";
    maxRuntimeTargets = 2;
    scope = "one symmetric relation with returnBehavior=symmetric: forward plus reverse nft accept rules";
  };
}
