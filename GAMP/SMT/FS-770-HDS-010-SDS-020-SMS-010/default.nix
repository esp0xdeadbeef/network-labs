{
  layer = "SMT";
  traceId = "FS-770-HDS-010-SDS-020-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-020-SMS-010-realization-fact-binding.md";
  titleSlug = "realization-fact-binding";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-020-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-770-HDS-010-SDS-020-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-770-HDS-010-SDS-020-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-770-HDS-010-SDS-020-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "focused-construction";
  };
  status = "OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs770-hds010-sds020-sms010-realization-fact-binding.sh";
    focusedTest = "tests/test-fs770-hds010-sds020-sms010-realization-fact-binding.sh";
    observedResult = "PASS: CLAB and NixOS HAT inventories emit a shared commonBehaviorSourceBinding with active seeded negatives for split behavior source and missing binding.";
  };
}
