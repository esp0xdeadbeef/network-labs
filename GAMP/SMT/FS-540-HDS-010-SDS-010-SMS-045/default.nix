{
  layer = "SMT";
  traceId = "FS-540-HDS-010-SDS-010-SMS-045";
  miniSmtId = "FS-540-HDS-010-SDS-010-SMS-045";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-540-HDS-010-SDS-010-SMS-045__recursive-client-to-access"
      "FS-540-HDS-010-SDS-010-SMS-045__local-client-to-access"
      "FS-540-HDS-010-SDS-010-SMS-045__local-dns-to-recursive-dns"
      "FS-540-HDS-010-SDS-010-SMS-045__recursive-client-to-local-dns"
      "FS-540-HDS-010-SDS-010-SMS-045__recursive-client-web-egress"
      "FS-540-HDS-010-SDS-010-SMS-045__recursive-dns-to-core"
      "FS-540-HDS-010-SDS-010-SMS-045__recursive-client-to-core"
      "FS-540-HDS-010-SDS-010-SMS-045__core-dns-to-provider"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-540-HDS-010-SDS-010-SMS-045";
    focusedTest = "tests/FS-540-HDS-010-SDS-010-SMS-045-prod-like-access-recursive-dns.sh";
    maxRuntimeTargets = 6;
    scope = "isolated dual-stack NixOS/CLAB recursive and local-only DNS with real s-router-test-clients endpoints, first-attempt selected egress, persistent listeners, and convergent dynamic routes; production VLANs excluded";
    observedResult = "NOT OK: the pushed dns-validation.gamp. fixture passed NixOS dual-stack iterative recursion, then local-only sharing failed. The staged policy path and source-selected routes were present, but the local-only resolver had no outgoing source binding; route lookup without the modeled local-dns address therefore failed before a packet was emitted. The row now requires the exact policy path plus dual-stack resolver source binding; an owning-layer correction and a new pushed cold stage remain required on NixOS and CLAB";
  };
}
