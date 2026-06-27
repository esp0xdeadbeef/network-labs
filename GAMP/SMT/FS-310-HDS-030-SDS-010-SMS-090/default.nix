{
  layer = "SMT";
  traceId = "FS-310-HDS-030-SDS-010-SMS-090";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-090-renderer-check-bypass-prevention.md";
  titleSlug = "renderer-check-bypass-prevention";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-090/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-090/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-090/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-090/inventory-test-clients.nix";
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
