{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-100";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-100-upstream-selector-shared-iface-ip-rule-priority.md";
  titleSlug = "upstream-selector-shared-iface-ip-rule-priority";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-100/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-100/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-100/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-100/inventory-test-clients.nix";
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
