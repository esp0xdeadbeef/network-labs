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
    observedResult = "NOT OK: after the valid NixOS provider RA source produced the selected IPv6 address/default, the live protocol reached recursive DNS and received a synthetic authoritative NXDOMAIN for test. from core Unbound. The fixture used dns-validation.test., which is a resolver special-use namespace and bypassed the controlled root. The source now uses the isolated non-special-use dns-validation.gamp. hierarchy; a new pushed cold stage remains required on NixOS and CLAB";
  };
}
