{
  layer = "SMT";
  traceId = "FS-540-HDS-010-SDS-010-SMS-020";
  miniSmtId = "dns-resolver-config";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh dns-resolver-config";
    focusedTest = "tests/test-active-lab-mini-smt-dns-resolver-config-only.sh";
    liveSitProbe = "tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh";
    maxRuntimeTargets = 5;
    scope = "CPM per-interface DNS resolver configuration authority over the smallest requester-policy-resolver path: access-dns, downstream-selector, policy, upstream-selector, resolver-node";
  };
}
