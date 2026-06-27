{
  layer = "SDS";
  traceId = "FS-340-HDS-010-SDS-010";
  purpose = "FS-340-HDS-010-SDS-010 software design — construction-only validation chain.";
  smsInputs = {
    "FS-340-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-340-HDS-010-SDS-010-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-340-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-340-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "source-stub-only";
    };
};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
