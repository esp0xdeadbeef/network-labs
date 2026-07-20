{
  layer = "SMT";
  traceId = "FS-310-HDS-020-SDS-010-SMS-190";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-020-SDS-010-SMS-190-renderer-pppoe-no-default-contract.md";
  titleSlug = "renderer-pppoe-no-default-contract";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-190/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-190/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-190/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-190/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
