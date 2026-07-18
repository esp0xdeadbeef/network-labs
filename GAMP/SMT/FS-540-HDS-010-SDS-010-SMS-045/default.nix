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
    observedResult = "NOT OK: the 2026-07-18 exact-source cold stage reached selected-egress6-nixos without a selected-table IPv6 default; both substrate fixtures exposed RA-only provider configuration without autonomous SLAAC, so the dual-stack first-attempt predicate remains unmet";
  };
}
