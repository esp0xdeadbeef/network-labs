{
  layer = "SIT";
  traceId = "FS-370-HDS-010-SDS-010";
  smsInputs = {
    "FS-370-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-370-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "unrelated-egress-route-denial";
      evidenceBoundary = "construction-only";
    };
    "FS-370-HDS-010-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-370-HDS-010-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/intent.nix";
      role = "lane-egress-binding";
    };
    "FS-370-HDS-010-SDS-010-SMS-101" = {
      smtRow = ../../SMT/FS-370-HDS-010-SDS-010-SMS-101;
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-101/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh lane-egress-binding";
    sourcePaths = [
      "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with one row-local SMS input without full HAT/SAT deployment";
  };
}
