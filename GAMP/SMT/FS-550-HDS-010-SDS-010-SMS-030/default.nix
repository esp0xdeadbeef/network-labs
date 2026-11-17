{
  layer = "SMT";
  traceId = "FS-550-HDS-010-SDS-010-SMS-030";
  canonicalSms = "the platform GAMP/SMS/FS-550-HDS-010-SDS-010-SMS-030.md";
  titleSlug = "bootstrap-dns-separation";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-550-HDS-010-SDS-010-SMS-030/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-550-HDS-010-SDS-010-SMS-030/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-550-HDS-010-SDS-010-SMS-030/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-550-HDS-010-SDS-010-SMS-030/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "the platform specification";
    observedResult = "canonical SMS mirrored from the platform specification; no focused mini-SMT or owning construction test is registered yet";
  };
}
