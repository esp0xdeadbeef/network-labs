{
  layer = "SMT";
  traceId = "FS-790-HDS-020-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-790-HDS-020-SDS-010-SMS-010-public-ingress-row-atomization.md";
  titleSlug = "public-ingress-row-atomization";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-790-HDS-020-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-790-HDS-020-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-790-HDS-020-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-790-HDS-020-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-only";
  };
  status = "OK";
  evidence = {
    observedResult = "PASS: 6 fixture rows atomized (2 per site: tcp+udp); each row has single publicSurface/protocol/publicPort/targetService/targetEndpoint/targetPort/returnPath; every row emits denied-variant records; every row requires external provider; every row references explicit public-exposure policy. Seeded negative multi-leg row correctly rejected. Seeded negative provider-binding-without-policy correctly rejected. All SMS acceptance predicates proven.";
  };
}
