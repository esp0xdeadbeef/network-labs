{
  layer = "SMT";
  traceId = "FS-310-HDS-040-SDS-010-SMS-170";
  canonicalSms = "canonical-gamp/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-170.md";
  titleSlug = "cpm-forwarding-intent-preservation";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-170/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-170/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-170/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-170/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from canonical-gamp; no focused mini-SMT or owning construction test is registered yet";
  };
}
