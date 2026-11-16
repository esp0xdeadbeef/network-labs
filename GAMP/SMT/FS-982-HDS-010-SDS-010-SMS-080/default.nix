{
  layer = "SMT";
  traceId = "FS-982-HDS-010-SDS-010-SMS-080";
  canonicalSms = "canonical-gamp/GAMP/SMS/FS-982-HDS-010-SDS-010-SMS-080.md";
  titleSlug = "sops-bootstrap-anti-pattern-rejection";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-080/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-080/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-080/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-080/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "canonical-gamp";
    observedResult = "canonical SMS mirrored from canonical-gamp; no focused mini-SMT or owning construction test is registered yet";
  };
}
