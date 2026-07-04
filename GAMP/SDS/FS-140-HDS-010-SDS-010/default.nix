{
  layer = "SDS";
  traceId = "FS-140-HDS-010-SDS-010";
  purpose = "Scoped Output Boundary source grouping.";
  smsInputs = {
    "FS-140-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-140-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
