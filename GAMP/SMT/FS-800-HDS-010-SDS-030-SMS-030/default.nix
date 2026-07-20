{
  layer = "SMT";
  traceId = "FS-800-HDS-010-SDS-030-SMS-030";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-030-SMS-030-hat-source-lock-selection.md";
  titleSlug = "hat-source-lock-selection";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-030-SMS-030/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-800-HDS-010-SDS-030-SMS-030/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-800-HDS-010-SDS-030-SMS-030/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-800-HDS-010-SDS-030-SMS-030/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
