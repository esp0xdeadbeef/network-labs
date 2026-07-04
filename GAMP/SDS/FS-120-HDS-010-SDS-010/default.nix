{
  layer = "SDS";
  traceId = "FS-120-HDS-010-SDS-010";
  purpose = "Deterministic Diagnostics construction-only grouping.";
  smsInputs = {
    "FS-120-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-120-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
