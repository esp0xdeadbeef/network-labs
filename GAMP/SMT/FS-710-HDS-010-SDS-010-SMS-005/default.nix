{
  layer = "SMT";
  traceId = "FS-710-HDS-010-SDS-010-SMS-005";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-710-HDS-010-SDS-010-SMS-005-lab-site-role-map.md";
  titleSlug = "lab-site-role-map";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-710-HDS-010-SDS-010-SMS-005/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-710-HDS-010-SDS-010-SMS-005/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-710-HDS-010-SDS-010-SMS-005/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-710-HDS-010-SDS-010-SMS-005/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
