{
  layer = "SMT";
  traceId = "FS-500-HDS-010-SDS-010-SMS-040";
  miniSmtId = "p2p-next-hop";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-500-HDS-010-SDS-010-SMS-040__mini-p2p-route-to-peer"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh p2p-next-hop";
    focusedTest = "tests/test-active-lab-mini-smt-p2p-next-hop-only.sh";
    maxRuntimeTargets = 2;
    scope = "one p2p link, two router endpoints, and one next-hop route atom";
  };
}
