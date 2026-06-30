{
  layer = "SMT";
  traceId = "FS-500-HDS-010-SDS-010-SMS-030";
  miniSmtId = "decision-reason-diagnostic";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-500-HDS-010-SDS-010-SMS-030__mini-decision-reason-diagnostic"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh decision-reason-diagnostic";
    liveCommand = "NETWORK_REPO_DIRECT_TEST_OK=1 S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs500-decision-reason-active-lab-runtime-check.sh --live";
    focusedTest = "tests/test-active-lab-mini-smt-decision-reason-diagnostic-only.sh";
    maxRuntimeTargets = 5;
    scope = "one reachability decision relation and traffic-path validation reason diagnostics over the five-node client -> downstream-selector -> policy -> upstream-selector -> testnet path";
  };
}
