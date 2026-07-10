{
  layer = "SMT";
  traceId = "FS-760-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-760-HDS-010-SDS-010-SMS-010-receiver-discovery-access-policy.md";
  titleSlug = "receiver-discovery-access-policy";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction";
  };
  status = "OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-760-HDS-010-SDS-010-SMS-010-receiver-discovery-access-policy.sh";
    focusedTest = "tests/test-FS-760-HDS-010-SDS-010-SMS-010-receiver-discovery-access-policy.sh";
    observedResult = "PASS: all 14 SMS predicates verified (P1-P14), SN1/SN2 active seeded negatives proven. Aggregate test-hat-printer-receiver-policy-source.sh PASS. Live mini-SMT runtime artifacts present on s-router-nixos and s-router-clab.";
  };
}
