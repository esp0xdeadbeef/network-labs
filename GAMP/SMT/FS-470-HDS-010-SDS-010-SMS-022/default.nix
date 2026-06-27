{
  layer = "SMT";
  traceId = "FS-470-HDS-010-SDS-010-SMS-022";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-022-wg-renderer-cpm-only-consumption.md";
  titleSlug = "wg-renderer-cpm-only-consumption";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-022/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-022/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-022/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-022/inventory-test-clients.nix";
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
