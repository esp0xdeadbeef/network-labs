{
  layer = "SMT";
  traceId = "FS-510-HDS-010-SDS-010-SMS-010";
  canonicalSms = "the platform GAMP/SMS/FS-510-HDS-010-SDS-010-SMS-010.md";
  titleSlug = "destination-ownership-boundary";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-510-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-510-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-510-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-510-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "the platform specification";
    observedResult = "canonical SMS mirrored from the platform specification; no focused mini-SMT or owning construction test is registered yet";
  };
}
