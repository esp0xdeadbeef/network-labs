{
  layer = "SMT";
  traceId = "FS-800-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-010-SMS-020-provider-access-canonical-stage-topology.md";
  titleSlug = "provider-access-canonical-stage-topology";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-020/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "OK";
  evidence = {
    observedResult = "8/8 SMS construction predicates PASS: offline topology checks, illegal bypass edge detection (5 edge classes), deterministic diagnostics, CPM stagePath and invalidPathCount, runtime targets, both seeded negatives. Evidence file: GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-020-online-eval.txt";
  };
}
