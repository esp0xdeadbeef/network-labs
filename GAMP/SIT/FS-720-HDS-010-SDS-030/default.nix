{
  layer = "SIT";
  traceId = "FS-720-HDS-010-SDS-030";
  smsInputs = {
    "FS-720-HDS-010-SDS-030-SMS-010" = {
      smtRow = ../../SMT/FS-720-HDS-010-SDS-030-SMS-010;
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-030-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    sourcePaths = [
      "GAMP/SMT/FS-720-HDS-010-SDS-030-SMS-010/intent.nix"
    ];
    observedResult = "Row-local SMT/SIT source stubs are parseable and addressable from network-labs.";
  };
}
