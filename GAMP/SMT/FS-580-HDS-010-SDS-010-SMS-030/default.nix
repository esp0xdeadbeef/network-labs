{
  layer = "SMT";
  traceId = "FS-580-HDS-010-SDS-010-SMS-030";
  canonicalSms = "canonical-gamp/GAMP/SMS/FS-580-HDS-010-SDS-010-SMS-030.md";
  titleSlug = "generic-egress-dns-bypass-denial";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-580-HDS-010-SDS-010-SMS-030/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-580-HDS-010-SDS-010-SMS-030/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-580-HDS-010-SDS-010-SMS-030/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-580-HDS-010-SDS-010-SMS-030/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "canonical-gamp";
    observedResult = "canonical SMS mirrored from canonical-gamp; no focused mini-SMT or owning construction test is registered yet";
  };
}
