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
    observedResult = "NOT OK on 2026-07-02: focused mini runner and small CPM proof verify lane egress binding, non-null testnet uplink annotation, and the selectable five-node active-lab runtime shape without full HAT/SAT deployment. Current live verifier failed: s-router-nixos 192.168.1.17 unreachable, s-router-clab artifact runtimeTargets=0, and s-router-test-clients missing the FS-370 host bridge/uplink materialization. The failure is preserved in network-codex-agent tests/observed-runtime-failures/test-20260702T181948Z-fs370-active-lab-live-stale-unreachable.sh with full log tests/observed-runtime-failures/logs/test-20260702T181948Z-fs370-active-lab-live-stale-unreachable.log. The row remains live NOT OK until the selected deployment is rebuilt and the same live verifier passes on s-router-nixos, s-router-clab, and s-router-test-clients.";
  };
}
