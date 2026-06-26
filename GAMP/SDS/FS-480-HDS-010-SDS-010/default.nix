{
  layer = "SDS";
  traceId = "FS-480-HDS-010-SDS-010";
  purpose = "FS-480-HDS-010-SDS-010 software design — construction-only validation chain.";
  smsInputs = {
    "FS-480-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-480-HDS-010-SDS-010-SMS-040;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
