{
  layer = "SDS";
  traceId = "FS-030-HDS-010-SDS-040";
  purpose = "Row-local SMS source stubs for FS-030-HDS-010-SDS-040.";
  smsInputs = {
    "FS-030-HDS-010-SDS-040-SMS-010" = {
      smsRow = ../../SMS/FS-030-HDS-010-SDS-040-SMS-010;
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
