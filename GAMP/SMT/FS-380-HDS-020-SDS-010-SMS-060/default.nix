{
  layer = "SMT";
  traceId = "FS-380-HDS-020-SDS-010-SMS-060";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-020-SDS-010-SMS-060-core-wan-ip-assignment.md";
  titleSlug = "core-wan-ip-assignment";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-060/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-060/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-060/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-060/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
