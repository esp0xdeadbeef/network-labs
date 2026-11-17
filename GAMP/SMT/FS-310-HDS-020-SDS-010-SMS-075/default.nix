{
  layer = "SMT";
  traceId = "FS-310-HDS-020-SDS-010-SMS-075";
  canonicalSms = "the platform GAMP/SMS/FS-310-HDS-020-SDS-010-SMS-075.md";
  titleSlug = "renderer-core-ingress-dnat-materialization";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-075/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-075/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-075/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-075/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    owningRepo = "the platform specification";
    observedResult = "canonical SMS mirrored from the platform specification; no focused mini-SMT or owning construction test is registered yet";
  };
}
