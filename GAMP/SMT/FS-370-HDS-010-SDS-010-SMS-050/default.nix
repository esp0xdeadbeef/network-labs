{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-050";
  miniSmtId = "lane-egress-binding";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-370-HDS-010-SDS-010-SMS-050__mini-client-to-testnet-uplink"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh lane-egress-binding";
    focusedTest = "tests/test-active-lab-mini-smt-lane-egress-binding-only.sh";
    maxRuntimeTargets = 5;
    evidenceBoundary = "split";
    scope = "CPM lane egress binding: tenant client to external testnet uplink with correct lane kind, non-null uplink annotation, and five-node active-lab runtime shape";
  };
}
