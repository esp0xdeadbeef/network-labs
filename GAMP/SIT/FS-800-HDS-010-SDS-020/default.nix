{
  layer = "SIT";
  traceId = "FS-800-HDS-010-SDS-020";
  smsInputs = {
    "FS-800-HDS-010-SDS-020-SMS-040" = {
      smtRow = ../../SMT/FS-800-HDS-010-SDS-020-SMS-040;
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix";
      role = "provider-access-default-route";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh provider-access-default-route";
    sourcePaths = [
      "GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with one row-local SMS input without full HAT/SAT deployment";
  };
}
