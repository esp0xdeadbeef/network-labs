{
  layer = "SIT";
  traceId = "FS-525-HDS-010-SDS-010";
  smsInputs = {
    "FS-525-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-525-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "named-core-resolver-binding";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "source specification only; integration has not executed";
  };
}
