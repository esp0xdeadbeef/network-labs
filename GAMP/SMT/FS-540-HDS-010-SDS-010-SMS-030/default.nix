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
    command = null;
    focusedTest = null;
    observedResult = "dual-stack isolated recursive and local-only source implemented; CPM and renderer construction predicates remain NOT OK until the owning CMC tests pass";
  };
}
