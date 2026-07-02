{
  layer = "SMT";
  traceId = "FS-310-HDS-030-SDS-010-SMS-080";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-080-renderer-shell-fallback-error-propagation.md";
  titleSlug = "renderer-shell-fallback-error-propagation";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-080/intent.nix";
    expectedRelationIds = [
      "FS-310-HDS-030-SDS-010-SMS-080__mini-verify"
    ];
    inventories = {
      clab = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-080/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-080/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-310-HDS-030-SDS-010-SMS-080/inventory-test-clients.nix";
    };
    evidenceBoundary = "active mini-SMT runtime wrapper; construction proof remains in the owning CLAB renderer";
  };
  status = "ACTIVE";
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-310-HDS-030-SDS-010-SMS-080";
    focusedTest = "../network-codex-agent/scripts/smt-live-FS-310-HDS-030-SDS-010-SMS-080.sh";
    maxRuntimeTargets = 5;
    observedResult = "registered in GAMP/SMT/mini-smt/tests.nix; live wrapper must fail unless the selected active-lab artifacts on s-router-nixos, s-router-clab, and s-router-test-clients prove the exact trace shape";
  };
}
