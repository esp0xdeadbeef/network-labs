{
  layer = "SMT";
  traceId = "FS-400-HDS-010-SDS-010-SMS-050";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-400-HDS-010-SDS-010-SMS-050-ula-wan-denial.md";
  titleSlug = "ula-wan-denial";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-050/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-050/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-050/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-050/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
