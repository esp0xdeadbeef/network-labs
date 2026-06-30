{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-050";
  miniSmtId = "FS-370-HDS-010-SDS-010-SMS-050";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-370-HDS-010-SDS-010-SMS-050__mini-client-to-testnet-uplink"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-050";
    focusedTest = "tests/test-active-lab-mini-smt-lane-egress-binding-only.sh";
    liveCommand = "NETWORK_REPO_DIRECT_TEST_OK=1 S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs370-active-lab-lane-egress-runtime-check.sh --live";
    maxRuntimeTargets = 5;
    evidenceBoundary = "split";
    scope = "CPM lane egress binding: tenant client to external testnet uplink with correct lane kind, non-null uplink annotation, and five-node active-lab runtime shape";
    observedResult = "2026-06-30: focused mini runner verifies lane egress binding, non-null testnet uplink annotation, and the selectable five-node active-lab runtime shape without full HAT/SAT deployment. Live verifier passed against s-router-nixos 192.168.1.17 and s-router-clab 192.168.1.19 with exactly client-edge, downstream-selector, policy, upstream-selector, and testnet-edge; s-router-test-clients 192.168.1.18 had zero row router containers and verified five rendered host bridges plus the testnet uplink.";
  };
}
