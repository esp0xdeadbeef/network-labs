{
  layer = "SMT";
  traceId = "FS-700-HDS-020-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-700-HDS-020-SDS-010-SMS-010-lab-source-validation-boundary.md";
  titleSlug = "lab-source-validation-boundary";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-700-HDS-020-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-700-HDS-020-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-700-HDS-020-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-700-HDS-020-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
