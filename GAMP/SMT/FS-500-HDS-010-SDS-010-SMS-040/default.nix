{
  layer = "SMT";
  traceId = "FS-500-HDS-010-SDS-010-SMS-040";
  miniSmtId = "FS-500-HDS-010-SDS-010-SMS-040";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-500-HDS-010-SDS-010-SMS-040__mini-p2p-route-to-peer"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-040";
    focusedTest = "tests/test-active-lab-mini-smt-p2p-next-hop-only.sh";
    liveCommand = "NETWORK_REPO_DIRECT_TEST_OK=1 S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs500-p2p-next-hop-active-lab-runtime-check.sh --live";
    maxRuntimeTargets = 5;
    scope = "one p2p next-hop route atom over the five-node router-a -> downstream-selector -> policy -> upstream-selector -> router-b path";
    observedResult = "2026-06-30: focused mini runner verifies p2p next-hop pairing, wrong-link next-hop rejection, self-next-hop rejection, and the selectable five-node current-lab runtime shape without full HAT/SAT deployment. Live verifier passed against s-router-nixos 192.168.1.17 and s-router-clab 192.168.1.19 with exactly router-a, downstream-selector, policy, upstream-selector, and router-b; s-router-test-clients 192.168.1.18 remained a client/substrate surface with no row router containers.";
  };
}
