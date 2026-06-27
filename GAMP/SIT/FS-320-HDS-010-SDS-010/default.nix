{
  layer = "SIT";
  traceId = "FS-320-HDS-010-SDS-010";
  smsInputs = {
    "FS-320-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-320-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-320-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-320-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-320-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-320-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = "bash tests/test-gamp-row-source-stubs.sh";
    sourcePaths = [
      "GAMP/SMT/FS-320-HDS-010-SDS-010-SMS-010/intent.nix"
      "GAMP/SMT/FS-320-HDS-010-SDS-010-SMS-020/intent.nix"
    ];
    observedResult = "Row-local SMT/SIT source stubs are parseable and addressable from network-labs.";
  };
}
