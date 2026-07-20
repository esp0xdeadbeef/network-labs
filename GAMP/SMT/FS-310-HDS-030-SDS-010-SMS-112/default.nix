{
  layer = "SMT";
  traceId = "FS-310-HDS-030-SDS-010-SMS-112";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-112-clab-fail-closed-contract.md";
  titleSlug = "clab-fail-closed-contract";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-112/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-112/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-112/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-112/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
