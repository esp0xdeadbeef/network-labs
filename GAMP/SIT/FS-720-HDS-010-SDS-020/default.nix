{
  layer = "SIT";
  traceId = "FS-720-HDS-010-SDS-020";
  smsInputs = {
    "FS-720-HDS-010-SDS-020-SMS-020" = {
      smtRow = ../../SMT/FS-720-HDS-010-SDS-020-SMS-020;
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-020/intent.nix";
      role = "endpoint-harness-consumption";
    };
    "FS-720-HDS-010-SDS-020-SMS-040" = {
      smtRow = ../../SMT/FS-720-HDS-010-SDS-020-SMS-040;
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-040/intent.nix";
      role = "test-clients-persistence-management";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = null;
    sourcePaths = [
      "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-020/intent.nix"
      "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-040/intent.nix"
    ];
    observedResult = "prepared source inputs only; endpoint-harness-consumption is not registered in GAMP/SMT/mini-smt/tests.nix and no executable focused mini-SMT script exists yet";
  };
}
