{
  layer = "SMT";
  traceId = "FS-310-HDS-040-SDS-010-SMS-150";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-150-cpm-platform-abstention.md";
  titleSlug = "cpm-platform-abstention";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/intent.nix";
    expectedRelationIds = [
      "FS-310-HDS-040-SDS-010-SMS-150__mini-verify"
    ];
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-150/inventory-test-clients.nix";
    };
    evidenceBoundary = "active mini-SMT runtime wrapper; construction proof remains in the owning CPM repository";
  };
  status = "ACTIVE";
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-310-HDS-040-SDS-010-SMS-150";
    focusedTest = "../network-codex-agent/scripts/smt-live-FS-310-HDS-040-SDS-010-SMS-150.sh";
    maxRuntimeTargets = 5;
    observedResult = "registered in GAMP/SMT/mini-smt/tests.nix; live wrapper must fail unless selected active-lab artifacts on s-router-nixos, s-router-clab, and s-router-test-clients prove the exact trace shape";
  };
}
