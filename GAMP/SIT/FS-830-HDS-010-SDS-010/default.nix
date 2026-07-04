{
  layer = "SIT";
  traceId = "FS-830-HDS-010-SDS-010";
  smsInputs = {
    "FS-830-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-830-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-830-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "sops-bootstrap-identity-active-lab-runtime-artifact";
      evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
    };
  };
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-830-HDS-010-SDS-010-SMS-040";
    liveCommand = "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-830-HDS-010-SDS-010-SMS-040.sh";
    observedResult = "NOT OK pending current live run: FS-830-HDS-010-SDS-010-SMS-040 now requires selected active-lab runtime artifact proof on s-router-nixos, s-router-clab, and s-router-test-clients; runtime target split is 5/5/0. Post-reboot decryptability remains HAT/SAT.";
  };
}
