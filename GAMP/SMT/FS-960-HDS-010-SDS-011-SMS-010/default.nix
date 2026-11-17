{
  layer = "SMT";
  traceId = "FS-960-HDS-010-SDS-011-SMS-010";
  canonicalSms = "the platform GAMP/SMS/FS-960-HDS-010-SDS-011-SMS-010.md";
  titleSlug = "readiness-predicate-owner-map";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-960-HDS-010-SDS-011-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-960-HDS-010-SDS-011-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-960-HDS-010-SDS-011-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-960-HDS-010-SDS-011-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "the platform specification";
    observedResult = "canonical SMS mirrored from the platform specification; no focused mini-SMT or owning construction test is registered yet";
  };
}
