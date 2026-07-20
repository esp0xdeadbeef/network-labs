{
  layer = "SMT";
  traceId = "FS-500-HDS-010-SDS-010-SMS-030";
  miniSmtId = "FS-500-HDS-010-SDS-010-SMS-030";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-500-HDS-010-SDS-010-SMS-030__mini-decision-reason-diagnostic"
    ];
  };
  evidence = {
    maxRuntimeTargets = 5;
    scope = "one reachability decision relation and traffic-path validation reason diagnostics over the five-node client -> downstream-selector -> policy -> upstream-selector -> testnet path";
    observedResult = "2026-06-30: offline verifier and live verifier passed. Live s-router-nixos 192.168.1.17 and s-router-clab 192.168.1.19 exposed exactly client-edge, downstream-selector, policy, upstream-selector, and core-vlan4-client-dhcp-slaac for decision-reason-diagnostic; s-router-test-clients 192.168.1.18 remained client-only with no decision-reason router containers.";
  };
}
