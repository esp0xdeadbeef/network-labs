{
  layer = "SMT";
  traceId = "FS-310-HDS-010-SDS-010-SMS-120";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-010-SDS-010-SMS-120-renderer-no-naming-inference.md";
  titleSlug = "renderer-no-naming-inference";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-120/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-120/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-120/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-120/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    command = null;
    focusedTest = null;
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
