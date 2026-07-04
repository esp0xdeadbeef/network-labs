{
  layer = "SMT";
  traceId = "FS-040-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md";
  titleSlug = "public-inventory-boundary";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-plus-live-active-lab-artifact";
  };
  status = "OK";
  evidence = {
    command = "network-codex-agent/scripts/smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh";
    focusedTest = "network-control-plane-model/tests/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.sh";
    sourceTest = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/test.sh";
    observedResult = "2026-07-04 full s-router-nixos rebuild loop passed active-lab post-reboot checks; direct rerun after CPM tmpdir fix also passed; s-router-nixos and s-router-clab artifacts each had runtimeTargets=5 publicInventoryAudits=15 traceHits=29, and s-router-test-clients had runtimeTargets=0 traceHits=1";
  };
}
