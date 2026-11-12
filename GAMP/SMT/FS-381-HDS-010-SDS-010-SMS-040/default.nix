{
  layer = "SMT";
  traceId = "FS-381-HDS-010-SDS-010-SMS-040";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-381-HDS-010-SDS-010-SMS-040.md";
  titleSlug = "canonical-sms";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-381-HDS-010-SDS-010-SMS-040/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-381-HDS-010-SDS-010-SMS-040/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-381-HDS-010-SDS-010-SMS-040/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-381-HDS-010-SDS-010-SMS-040/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
