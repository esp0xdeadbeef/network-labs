{
  layer = "SIT";
  traceId = "FS-705-HDS-010-SDS-010";
  smsInputs = {
    "FS-705-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-705-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-705-HDS-010-SDS-010-SMS-010/default.nix";
      evidenceBoundary = "construction-only";
    };
    "FS-705-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-705-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-705-HDS-010-SDS-010-SMS-020/default.nix";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "tests/test-gamp-sds-sms-template-mapping.sh";
    sourcePaths = [
      "GAMP/SMT/FS-705-HDS-010-SDS-010-SMS-010/default.nix"
      "GAMP/SMT/FS-705-HDS-010-SDS-010-SMS-020/default.nix"
    ];
  };
}
