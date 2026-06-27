{
  layer = "SDS";
  traceId = "FS-960-HDS-010-SDS-013";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-960-HDS-010-SDS-013-SMS-010" = {
      smsRow = ../../SMS/FS-960-HDS-010-SDS-013-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
