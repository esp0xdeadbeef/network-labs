{
  layer = "SMT";
  traceId = "FS-800-HDS-010-SDS-030-SMS-010";
  canonicalSms = "canonical-gamp/GAMP/SMS/FS-800-HDS-010-SDS-030-SMS-010.md";
  titleSlug = "hat-intent-inventory-boundary";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-030-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-800-HDS-010-SDS-030-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-800-HDS-010-SDS-030-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-800-HDS-010-SDS-030-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "canonical-gamp";
    observedResult = "canonical SMS mirrored from canonical-gamp; no focused mini-SMT or owning construction test is registered yet";
  };
}
