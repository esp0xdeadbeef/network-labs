{
  layer = "SMT";
  traceId = "FS-982-HDS-010-SDS-010-SMS-100";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-982-HDS-010-SDS-010-SMS-100-profile-metadata-field-declaration.md";
  titleSlug = "profile-metadata-field-declaration";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-100/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-100/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-100/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-100/inventory-test-clients.nix";
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
