{
  layer = "SMT";
  traceId = "FS-310-HDS-030-SDS-010-SMS-111";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-111-nixos-fail-closed-contract.md";
  titleSlug = "nixos-fail-closed-contract";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-111/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-111/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-111/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-111/inventory-test-clients.nix";
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
