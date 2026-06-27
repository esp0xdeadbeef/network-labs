{
  layer = "SDS";
  traceId = "FS-720-HDS-010-SDS-030";
  purpose = "Row-local SMS source stubs for FS-720-HDS-010-SDS-030.";
  smsInputs = {
    "FS-720-HDS-010-SDS-030-SMS-010" = {
      smsRow = ../../SMS/FS-720-HDS-010-SDS-030-SMS-010;
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
