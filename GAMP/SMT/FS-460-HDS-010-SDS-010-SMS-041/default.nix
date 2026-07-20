{
  layer = "SMT";
  traceId = "FS-460-HDS-010-SDS-010-SMS-041";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-460-HDS-010-SDS-010-SMS-041-nebula-fail-closed-contract.md";
  titleSlug = "nebula-fail-closed-contract";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-041/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-041/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-041/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-041/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
