{
  layer = "SIT";
  traceId = "FS-030-HDS-010-SDS-040";
  smsInputs = {
    "FS-030-HDS-010-SDS-040-SMS-010" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-040-SMS-010;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-040-SMS-010/intent.nix";
      role = "row-local-mini-smt";
      evidenceBoundary = "row-local-mini-smt";
    };
  };
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010";
    sourcePaths = [
      "GAMP/SMT/FS-030-HDS-010-SDS-040-SMS-010/intent.nix"
    ];
    observedResult = "Row-local mini-SMT source is registered for live NixOS and CLAB runtime verification with zero test-client runtime targets; current live evidence must be refreshed before claiming this row complete.";
  };
}
