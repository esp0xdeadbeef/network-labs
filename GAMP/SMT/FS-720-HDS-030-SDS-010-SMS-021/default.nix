{
  layer = "SMT";
  traceId = "FS-720-HDS-030-SDS-010-SMS-021";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-030-SDS-010-SMS-021-ae-cpm-only-consumption.md";
  titleSlug = "ae-cpm-only-consumption";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-021/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-021/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-021/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-021/inventory-test-clients.nix";
    };
    evidenceBoundary = "owning-renderer-construction-evidence";
  };
  status = "OK";
  evidence = {
    observedResult = "OK on 2026-06-29: owning access-endpoint renderer construction test passes; endpoint fixture data is consumed from CPM endpointAssignment, direct raw intent/inventory rediscovery and CPM-missing fallback recovery are rejected, and SMS-021 diagnostic guards are verified";
  };
}
