{
  layer = "SMT";
  traceId = "FS-982-HDS-010-SDS-010-SMS-090";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-982-HDS-010-SDS-010-SMS-090-platform-native-service-grouping.md";
  titleSlug = "platform-native-service-grouping";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-090/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-090/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-090/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-090/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
