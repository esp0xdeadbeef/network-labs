{
  layer = "SDS";
  traceId = "FS-270-HDS-010-SDS-010";
  purpose = "Policy-Point Transit Software Design — construction-only validation for the FS-270 selector handoff transport forwarding boundary chain.";
  smsInputs = {
    "FS-270-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-270-HDS-010-SDS-010-SMS-010;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-270-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-270-HDS-010-SDS-010-SMS-020;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-270-HDS-010-SDS-010-SMS-030" = {
      smsRow = ../../SMS/FS-270-HDS-010-SDS-010-SMS-030;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-270-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-270-HDS-010-SDS-010-SMS-040;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
