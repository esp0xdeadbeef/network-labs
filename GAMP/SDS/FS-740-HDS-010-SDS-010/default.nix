{
  layer = "SDS";
  traceId = "FS-740-HDS-010-SDS-010";
  purpose = "FS-740-HDS-010-SDS-010 software design — construction-only validation chain.";
  smsInputs = {
    "FS-740-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-740-HDS-010-SDS-010-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
