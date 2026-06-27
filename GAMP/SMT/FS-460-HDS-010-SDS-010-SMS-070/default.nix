{
  layer = "SMT";
  traceId = "FS-460-HDS-010-SDS-010-SMS-070";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-460-HDS-010-SDS-010-SMS-070-nebula-hardcoded-value-prevention.md";
  titleSlug = "nebula-hardcoded-value-prevention";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-070/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-070/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-070/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-070/inventory-test-clients.nix";
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
