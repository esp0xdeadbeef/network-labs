{
  layer = "SMT";
  traceId = "FS-800-HDS-020-SDS-021-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.md";
  titleSlug = "hat-emulated-test-secret-materialization";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/inventory-test-clients.nix";
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
