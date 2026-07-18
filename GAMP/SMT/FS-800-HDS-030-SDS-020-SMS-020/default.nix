{
  layer = "SMT";
  traceId = "FS-800-HDS-030-SDS-020-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-020-s-router-prod-pppoe-ipv6-prefix-delegation.md";
  titleSlug = "s-router-prod-pppoe-ipv6-prefix-delegation";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-020/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-020/inventory-test-clients.nix";
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
