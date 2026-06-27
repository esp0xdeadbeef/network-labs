{
  layer = "SIT";
  traceId = "FS-400-HDS-010-SDS-010";
  smsInputs = {
    "FS-400-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-400-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "ula-nat66-selection";
    };
    "FS-400-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-400-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "overlay-client-gua-mode";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh ula-nat66-selection";
    sourcePaths = [
      "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-020/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with one row-local SMS input without full HAT/SAT deployment";
  };
}
