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
    command = "tests/run-active-lab-mini-smt.sh endpoint-harness-consumption";
    sourcePaths = [
      "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-020/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with one row-local SMS input without full HAT/SAT deployment";
  };
}
