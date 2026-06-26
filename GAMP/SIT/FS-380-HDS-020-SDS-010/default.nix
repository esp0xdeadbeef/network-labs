{
  layer = "SIT";
  traceId = "FS-380-HDS-020-SDS-010";
  smsInputs = {
    "FS-380-HDS-020-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-380-HDS-020-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-050/intent.nix";
      role = "internet-mode-verification";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh internet-mode-verification";
    sourcePaths = [
      "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-050/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with one row-local SMS input without full HAT/SAT deployment";
  };
}
