{
  layer = "SMT";
  traceId = "FS-310-HDS-040-SDS-010-SMS-150";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-150-cpm-platform-abstention.md";
  titleSlug = "cpm-platform-abstention";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/inventory-test-clients.nix";
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
