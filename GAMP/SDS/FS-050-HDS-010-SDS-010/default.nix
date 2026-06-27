{
  layer = "SDS";
  traceId = "FS-050-HDS-010-SDS-010";
  purpose = "Protected inventory boundary mini POC input grouping.";
  smsInputs = {
    "FS-050-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-050-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
