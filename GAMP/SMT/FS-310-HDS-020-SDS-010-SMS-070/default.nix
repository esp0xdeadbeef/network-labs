{
  layer = "SMT";
  traceId = "FS-310-HDS-020-SDS-010-SMS-070";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-020-SDS-010-SMS-070-renderer-nat-nat66-primitive-source-binding.md";
  titleSlug = "renderer-nat-nat66-primitive-source-binding";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-070/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-070/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-070/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-070/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
