{
  layer = "SMT";
  traceId = "FS-310-HDS-010-SDS-010-SMS-130";
  canonicalSms = "canonical-gamp/GAMP/SMS/FS-310-HDS-010-SDS-010-SMS-130.md";
  titleSlug = "renderer-no-policy-invention";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-130/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-130/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-130/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-130/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "canonical-gamp";
    observedResult = "canonical SMS mirrored from canonical-gamp; no focused mini-SMT or owning construction test is registered yet";
  };
}
