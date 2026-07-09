{
  layer = "SMT";
  traceId = "FS-710-HDS-020-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-710-HDS-020-SDS-010-SMS-010-profile-realization-role-boundary.md";
  titleSlug = "profile-realization-role-boundary";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-710-HDS-020-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-710-HDS-020-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-710-HDS-020-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-710-HDS-020-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs710-hds020-sds010-sms010-profile-realization-role-boundary.sh";
    focusedTest = "tests/test-fs710-hds020-sds010-sms010-profile-realization-role-boundary.sh";
    observedResult = "2026-07-09 re-verification: NOT_OK→OK. Construction test PASS (192 lines, 2 seeded negatives + recovery). All 7 SMS predicates proven. Live SMT wrapper PASS: CPM artifact present on 3/3 lab hosts with 1 runtimeTarget each. 5-node canonical topology, 1 valid traffic path, private NAT44, IPv6 fail-closed. Preflight v10: lock-bump OK, all hosts online after fresh s-sigma rebuild. Evidence file: network-codex-agent/GAMP/SMT/FS-710-HDS-020-SDS-010-SMS-010-online-eval.txt";
  };
}
