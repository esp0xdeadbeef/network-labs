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
    maxRuntimeTargets = 5;
    scope = "one p2p next-hop route atom over the five-node router-a -> downstream-selector -> policy -> upstream-selector -> router-b path";
    observedResult = "2026-06-30: focused mini runner verifies p2p next-hop pairing, wrong-link next-hop rejection, self-next-hop rejection, and the selectable five-node current-lab runtime shape without full HAT/SAT deployment. Live verifier passed against s-router-nixos 192.168.1.17 and s-router-clab 192.168.1.19 with exactly router-a, downstream-selector, policy, upstream-selector, and router-b; s-router-test-clients 192.168.1.18 remained a client/substrate surface with no row router containers.";
  };
}
