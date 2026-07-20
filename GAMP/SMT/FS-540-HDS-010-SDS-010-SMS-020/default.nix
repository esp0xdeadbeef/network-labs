{
  layer = "SMT";
  traceId = "FS-540-HDS-010-SDS-010-SMS-020";
  miniSmtId = "FS-540-HDS-010-SDS-010-SMS-020";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns"
      "FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet"
      "FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet"
    ];
  };
  evidence = {
    maxRuntimeTargets = 5;
    scope = "CPM per-interface DNS resolver configuration authority over the smallest requester-policy-resolver path: access-dns, downstream-selector, policy, upstream-selector, resolver-node";
    observedResult = "OK live on 2026-06-30: row-local tests and the live FS-540 active-lab DNS verifier passed. The SMT source selects the five-node resolver path, emits local-recursive/dhcp-provided/no-public-fallback resolver-source authority, requires the row-local s-router-test-clients endpoint source, and proves that s-router-test-clients renders the dns-resolver-config-access-dns endpoint without router containers. Runtime proof on 192.168.1.17 and 192.168.1.19 resolves cache.nixos.org from access-dns through the modeled recursive path; 192.168.1.18 runs the endpoint-only container/bridge needed by this row.";
  };
}
