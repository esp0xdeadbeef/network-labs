{
  layer = "SIT";
  traceId = "FS-540-HDS-010-SDS-010";
  smsInputs = {
    "FS-540-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "dns-resolver-config";
    };
    "FS-540-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-040;
      role = "requester-lane-recursive-reachability";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh dns-resolver-config";
    sourcePaths = [
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with one row-local SMS input without full HAT/SAT deployment";
  };
}
