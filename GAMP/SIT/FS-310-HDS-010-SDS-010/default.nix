{
  layer = "SIT";
  traceId = "FS-310-HDS-010-SDS-010";
  smsInputs = {
    "FS-310-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-310-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-030/intent.nix";
      role = "policy-router-relation-identity";
    };
    "FS-310-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-310-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh policy-router-relation-identity";
    sourcePaths = [
      "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-030/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with one row-local SMS input without full HAT/SAT deployment";
  };
}
