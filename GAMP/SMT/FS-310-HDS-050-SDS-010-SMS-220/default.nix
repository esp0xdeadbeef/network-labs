{
  layer = "SMT";
  traceId = "FS-310-HDS-050-SDS-010-SMS-220";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-050-SDS-010-SMS-220-test-input-pinning.md";
  titleSlug = "test-input-pinning";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-050-SDS-010-SMS-220/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-050-SDS-010-SMS-220/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-050-SDS-010-SMS-220/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-050-SDS-010-SMS-220/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
