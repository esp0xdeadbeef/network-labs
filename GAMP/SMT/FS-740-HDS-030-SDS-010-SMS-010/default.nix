{
  layer = "SMT";
  traceId = "FS-740-HDS-030-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-740-HDS-030-SDS-010-SMS-010-printer-payload-admin-surfaces.md";
  titleSlug = "printer-payload-admin-surfaces";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-740-HDS-030-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-740-HDS-030-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-740-HDS-030-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-740-HDS-030-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
