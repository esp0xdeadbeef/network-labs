{
  layer = "SMT";
  traceId = "FS-320-HDS-040-SDS-010-SMS-060";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-040-SDS-010-SMS-060-nixos-interface-role-classification.md";
  titleSlug = "nixos-interface-role-classification";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-320-HDS-040-SDS-010-SMS-060/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-320-HDS-040-SDS-010-SMS-060/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-320-HDS-040-SDS-010-SMS-060/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-320-HDS-040-SDS-010-SMS-060/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
