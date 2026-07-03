{
  layer = "SMT";
  traceId = "FS-540-HDS-010-SDS-010-SMS-045";
  miniSmtId = "FS-540-HDS-010-SDS-010-SMS-045";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-540-HDS-010-SDS-010-SMS-045__prod-like-client-to-access-dns"
      "FS-540-HDS-010-SDS-010-SMS-045__prod-like-access-dns-to-vlan4"
      "FS-540-HDS-010-SDS-010-SMS-045__prod-like-client-to-vlan4-internet"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-540-HDS-010-SDS-010-SMS-045";
    focusedTest = "tests/FS-540-HDS-010-SDS-010-SMS-045-prod-like-access-recursive-dns.sh";
    maxRuntimeTargets = 5;
    scope = "SMT/SIT-only prod-like access recursive DNS: access-vlan2 -> downstream-selector -> policy -> upstream-selector -> core, real s-router-test-clients endpoint, VLAN4 NAT upstream, no PPPoE dependency";
    observedResult = "2026-07-03 locked active-lab full loop passed for FS-540-HDS-010-SDS-010-SMS-045; evidence directory /tmp/s-router-live-smoke/FS-540-HDS-010-SDS-010-SMS-045/20260703T200952Z. Manual enumeration proved prod-like-dns-client01 and prod-like-dns-clab-client01 use gateway/resolver 10.54.45.1, resolve cache.nixos.org through the access DNS service, and trace through access-vlan2, downstream-selector, policy, upstream-selector, and core. This is SMT/SIT evidence only.";
  };
}
