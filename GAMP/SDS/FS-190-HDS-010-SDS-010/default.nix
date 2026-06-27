{
  layer = "SDS";
  traceId = "FS-190-HDS-010-SDS-010";
  purpose = "Row-local SMS source stubs for FS-190-HDS-010-SDS-010.";
  smsInputs = {
    "FS-190-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-190-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-gamp-row-source-stubs.sh"
  ];
}
