{
  layer = "SMT";
  traceId = "FS-940-HDS-010-SDS-010-SMS-060";
  canonicalSms = "canonical-gamp/GAMP/SMS/FS-940-HDS-010-SDS-010-SMS-060.md";
  titleSlug = "nix-evaluator-diagnostic-profile";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-010-SMS-060/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-940-HDS-010-SDS-010-SMS-060/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-940-HDS-010-SDS-010-SMS-060/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-940-HDS-010-SDS-010-SMS-060/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "canonical-gamp";
    observedResult = "canonical SMS mirrored from canonical-gamp; no focused mini-SMT or owning construction test is registered yet";
  };
}
