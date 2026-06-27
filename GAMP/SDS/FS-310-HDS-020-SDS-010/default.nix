{
  layer = "SDS";
  traceId = "FS-310-HDS-020-SDS-010";
  purpose = "FS-310-HDS-020-SDS-010 software design — construction-only validation chain.";
  smsInputs = {
    "FS-310-HDS-020-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-310-HDS-020-SDS-010-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-310-HDS-020-SDS-010-SMS-200" = {
      smsRow = ../../SMS/FS-310-HDS-020-SDS-010-SMS-200;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "source-stub-only";
    };
};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
