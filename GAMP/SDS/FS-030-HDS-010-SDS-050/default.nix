{
  layer = "SDS";
  traceId = "FS-030-HDS-010-SDS-050";
  purpose = "Core role boundary source grouping.";
  smsInputs = {
    "FS-030-HDS-010-SDS-050-SMS-010" = {
      smsRow = ../../SMS/FS-030-HDS-010-SDS-050-SMS-010;
      miniSmtIds = [ "FS-030-HDS-010-SDS-050-SMS-010" "canonical-source-stub" ];
      inputKinds = [ "intent-source" "source-reference" ];
      evidenceBoundary = "construction-plus-live-artifact";
    };
  };
  templateTests = [
    "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh"
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
