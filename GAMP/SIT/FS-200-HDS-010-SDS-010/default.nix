{
  layer = "SIT";
  traceId = "FS-200-HDS-010-SDS-010";
  smsInputs = {
    "FS-200-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-200-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-200-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = "bash tests/test-gamp-row-source-stubs.sh";
    sourcePaths = [
      "GAMP/SMT/FS-200-HDS-010-SDS-010-SMS-010/intent.nix"
    ];
    observedResult = "Row-local SMT/SIT source stubs are parseable and addressable from network-labs.";
  };
}
