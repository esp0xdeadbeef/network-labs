{
  layer = "SMT";
  traceId = "FS-310-HDS-040-SDS-010-SMS-101";
  canonicalSms = "canonical-gamp/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-101.md";
  titleSlug = "nixos-cpm-only-consumption";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-101/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-101/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-101/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-101/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "canonical-gamp";
    observedResult = "canonical SMS mirrored from canonical-gamp; no focused mini-SMT or owning construction test is registered yet";
  };
}
