{
  layer = "SMT";
  traceId = "FS-380-HDS-020-SDS-010-SMS-120";
  miniSmtId = "FS-380-HDS-020-SDS-010-SMS-120";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-380-HDS-020-SDS-010-SMS-120__prod-like-client-to-access-dns"
      "FS-380-HDS-020-SDS-010-SMS-120__prod-like-access-dns-to-vlan4"
      "FS-380-HDS-020-SDS-010-SMS-120__prod-like-client-to-vlan4-internet"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-380-HDS-020-SDS-010-SMS-120";
    focusedTest = "tests/FS-380-HDS-020-SDS-010-SMS-120-prod-like-vlan4-client-egress.sh";
    maxRuntimeTargets = 5;
    scope = "SMT/SIT-only prod-like IPv4 client egress and access DNS recursion: access-vlan2 -> downstream-selector -> policy -> upstream-selector -> core, real s-router-test-clients endpoint, VLAN4 NAT upstream, no PPPoE dependency";
  };
}
