{
  layer = "SMT";
  traceId = "FS-830-HDS-010-SDS-010-SMS-040";
  evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-830-HDS-010-SDS-010-SMS-040/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-830-HDS-010-SDS-010-SMS-040/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-830-HDS-010-SDS-010-SMS-040/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-830-HDS-010-SDS-010-SMS-040/inventory-test-clients.nix";
    };
    expectedRelationIds = [ "FS-830-HDS-010-SDS-010-SMS-040__mini-verify" ];
    expectedRuntimeTargets = {
      "s-router-nixos" = 5;
      "s-router-clab" = 5;
      "s-router-test-clients" = 0;
    };
    evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  };
  evidence = {
    owningRepo = "network-codex-agent";
    focusedTest = "tests/FS-830-HDS-010-SDS-010-SMS-040.sh";
    liveScript = "../network-codex-agent/scripts/smt-live-FS-830-HDS-010-SDS-010-SMS-040.sh";
    command = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-830-HDS-010-SDS-010-SMS-040";
    smtRow = "GAMP/SMT/README.md";
    status = "NOT OK";
    verifiedAt = "pending active-lab runtime artifact verification";
    scope = "SMT/SIT runtime artifact proof on s-router-nixos, s-router-clab, and s-router-test-clients; live decryptability remains HAT/SAT.";
  };
}
