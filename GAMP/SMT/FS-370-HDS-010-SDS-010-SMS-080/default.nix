{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-080";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-080-upstream-selector-default-route.md";
  titleSlug = "upstream-selector-default-route";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-080/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-080/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-080/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-080/inventory-test-clients.nix";
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
