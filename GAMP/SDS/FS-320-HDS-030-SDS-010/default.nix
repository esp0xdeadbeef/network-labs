{
  layer = "SDS";
  traceId = "FS-320-HDS-030-SDS-010";
  purpose = "FS-320-HDS-030-SDS-010 software design — construction-only validation chain.";
  smsInputs = {
    "FS-320-HDS-030-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-320-HDS-030-SDS-010-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
