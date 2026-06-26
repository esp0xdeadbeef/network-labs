{
  layer = "SDS";
  traceId = "FS-940-HDS-010-SDS-020";
  purpose = "FS-940-HDS-010-SDS-020 software design — construction-only validation chain.";
  smsInputs = {
    "FS-940-HDS-010-SDS-020-SMS-040" = {
      smsRow = ../../SMS/FS-940-HDS-010-SDS-020-SMS-040;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
