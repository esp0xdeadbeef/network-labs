{
  layer = "SMT";
  traceId = "FS-540-HDS-010-SDS-010-SMS-020";
  miniSmtId = "FS-540-HDS-010-SDS-010-SMS-020";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns"
      "FS-540-HDS-010-SDS-010-SMS-020__mini-client-web-to-testnet"
      "FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-to-core-dns"
      "FS-540-HDS-010-SDS-010-SMS-020__mini-core-dns-to-testnet"
    ];
  };
  evidence = {
    maxRuntimeTargets = 5;
    scope = "CPM per-interface DNS resolver configuration authority over the smallest requester-policy-resolver path: access-dns, downstream-selector, policy, upstream-selector, resolver-node";
    observedResult = "Construction source migrated to the named access-to-core resolver binding. Prior live evidence is superseded and shall not be used for acceptance; a new isolated NixOS, CLAB, and test-client cold stage is required.";
  };
}
