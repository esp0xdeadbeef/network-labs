{
  layer = "SMT";
  traceId = "FS-970-HDS-010-SDS-020-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-020-non-public-reservation-identity-source.md";
  titleSlug = "non-public-reservation-identity-source";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-020/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-020/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
