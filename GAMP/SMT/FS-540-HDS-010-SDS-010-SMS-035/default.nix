{
  layer = "SMT";
  traceId = "FS-540-HDS-010-SDS-010-SMS-035";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-035-renderer-dns-nft-materialization.md";
  titleSlug = "renderer-dns-nft-materialization";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-035/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-035/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-035/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-035/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    command = null;
    focusedTest = null;
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
