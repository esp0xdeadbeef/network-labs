{
  layer = "SMT";
  traceId = "FS-570-HDS-010-SDS-010-SMS-020";
  canonicalSms = "the platform GAMP/SMS/FS-570-HDS-010-SDS-010-SMS-020.md";
  titleSlug = "split-horizon-fallback-binding";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-570-HDS-010-SDS-010-SMS-020/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-570-HDS-010-SDS-010-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-570-HDS-010-SDS-010-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-570-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "the platform specification";
    observedResult = "canonical SMS mirrored from the platform specification; no focused mini-SMT or owning construction test is registered yet";
  };
}
