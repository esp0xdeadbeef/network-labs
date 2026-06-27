{
  layer = "SMT";
  traceId = "FS-770-HDS-010-SDS-020-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-020-SMS-020-nixos-realization-fact-binding.md";
  titleSlug = "nixos-realization-fact-binding";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-020-SMS-020/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-770-HDS-010-SDS-020-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-770-HDS-010-SDS-020-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-770-HDS-010-SDS-020-SMS-020/inventory-test-clients.nix";
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
