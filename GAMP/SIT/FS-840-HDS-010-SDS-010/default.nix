{
  layer = "SIT";
  traceId = "FS-840-HDS-010-SDS-010";
  smsInputs = {
    "FS-840-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-840-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-840-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "sops-impermanence-active-lab-runtime-artifact";
      evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
    };
  };
  evidence = {
    observedResult = "NOT OK pending current live run: FS-840-HDS-010-SDS-010-SMS-040 now requires selected active-lab runtime artifact proof on s-router-nixos, s-router-clab, and s-router-test-clients; runtime target split is 5/5/0. Post-reboot secret delivery remains HAT/SAT.";
  };
}
