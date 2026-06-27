{
  layer = "SMT";
  traceId = "FS-820-HDS-010-SDS-010-SMS-050";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-050-network-labs-sops-configuration-validation.md";
  titleSlug = "network-labs-sops-configuration-validation";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/inventory-test-clients.nix";
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
