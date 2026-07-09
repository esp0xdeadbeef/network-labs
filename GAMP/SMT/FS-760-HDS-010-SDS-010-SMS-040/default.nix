{
  layer = "SMT";
  traceId = "FS-760-HDS-010-SDS-010-SMS-040";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-760-HDS-010-SDS-010-SMS-040-receiver-tenant-management-denial.md";
  titleSlug = "receiver-tenant-management-denial";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-040/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-040/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-040/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-040/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-only";
  };
  status = "OK";
  evidence = {
    command = "bash tests/test-FS-760-HDS-010-SDS-010-SMS-040-receiver-tenant-management-denial.sh";
    focusedTest = "tests/test-FS-760-HDS-010-SDS-010-SMS-040-receiver-tenant-management-denial.sh";
    observedResult = "Focused SMS-040 construction test PASS (8/8 predicates, 2/2 seeded negatives active). Row-local structural test PASS (10/10). Aggregate hat-printer-receiver-policy-source test PASS. Mini-SMT list: 0 runtime targets (construction-only). Pinned nixos-shell build PASS.";
  };
}
