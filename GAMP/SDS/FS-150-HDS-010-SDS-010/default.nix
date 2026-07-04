{
  layer = "SDS";
  traceId = "FS-150-HDS-010-SDS-010";
  purpose = "Portable Meaning Contract source grouping.";
  smsInputs = {
    "FS-150-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-150-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
