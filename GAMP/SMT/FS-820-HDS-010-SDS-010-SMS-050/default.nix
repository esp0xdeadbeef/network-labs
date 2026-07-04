{
  layer = "SMT";
  traceId = "FS-820-HDS-010-SDS-010-SMS-050";
  evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-050-network-labs-sops-configuration-validation.md";
  titleSlug = "network-labs-sops-configuration-validation";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/inventory-test-clients.nix";
    };
    expectedRelationIds = [ "FS-820-HDS-010-SDS-010-SMS-050__mini-verify" ];
    expectedRuntimeTargets = {
      "s-router-nixos" = 5;
      "s-router-clab" = 5;
      "s-router-test-clients" = 0;
    };
    evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  };
  status = "NOT OK";
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-820-HDS-010-SDS-010-SMS-050";
    constructionCommand = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-820-HDS-010-SDS-010-SMS-050.sh";
    focusedTest = "tests/FS-820-HDS-010-SDS-010-SMS-050.sh";
    liveScript = "../network-codex-agent/scripts/smt-live-FS-820-HDS-010-SDS-010-SMS-050.sh";
    observedResult = "NOT OK pending current live run: construction guard passed on 2026-06-30, but this row now also requires active-lab runtime artifact proof on s-router-nixos, s-router-clab, and s-router-test-clients with runtime target counts 5/5/0.";
  };
}
