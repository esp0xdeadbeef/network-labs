{
  layer = "SMT";
  traceId = "FS-540-HDS-010-SDS-010-SMS-030";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-030-recursive-authority-separation.md";
  titleSlug = "recursive-authority-separation";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-030/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-030/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-030/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-030/inventory-test-clients.nix";
    };
    expectedRelationIds = [
      "FS-540-HDS-010-SDS-010-SMS-030__recursive-client-to-access"
      "FS-540-HDS-010-SDS-010-SMS-030__local-client-to-access"
      "FS-540-HDS-010-SDS-010-SMS-030__local-dns-to-recursive-dns"
      "FS-540-HDS-010-SDS-010-SMS-030__recursive-client-web-egress"
      "FS-540-HDS-010-SDS-010-SMS-030__recursive-dns-to-core"
      "FS-540-HDS-010-SDS-010-SMS-030__core-dns-to-provider"
    ];
    evidenceBoundary = "compiler-through-renderer-construction";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "NOT OK: the isolated dual-stack recursive and local-only source is present, but acceptance remains open until the row-specific CPM and renderer predicates and the cold-staged NixOS/CLAB protocol pass";
  };
}
