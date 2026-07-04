{
  layer = "SDS";
  traceId = "FS-160-HDS-010-SDS-010";
  purpose = "Portability Limitation Reporting source grouping.";
  smsInputs = {
    "FS-160-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-160-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
