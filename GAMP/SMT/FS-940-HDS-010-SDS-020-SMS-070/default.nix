{
  layer = "SMT";
  traceId = "FS-940-HDS-010-SDS-020-SMS-070";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-940-HDS-010-SDS-020-SMS-070-one-pass-route-materializer.md";
  titleSlug = "one-pass-route-materializer";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-070/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-070/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-070/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-070/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
