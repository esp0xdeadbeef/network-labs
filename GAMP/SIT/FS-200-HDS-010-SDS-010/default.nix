{
  layer = "SIT";
  traceId = "FS-200-HDS-010-SDS-010";
  smsInputs = {
    "FS-200-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-200-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-200-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "shared-service-exposure-boundary";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh shared-service-exposure-boundary";
    sourcePaths = [
      "GAMP/SMT/FS-200-HDS-010-SDS-010-SMS-010/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with one row-local SMS input without full HAT/SAT deployment";
  };
}
