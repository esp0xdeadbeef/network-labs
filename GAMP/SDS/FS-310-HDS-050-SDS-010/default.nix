{
  layer = "SDS";
  traceId = "FS-310-HDS-050-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-310-HDS-050-SDS-010-SMS-220" = {
      smsRow = ../../SMS/FS-310-HDS-050-SDS-010-SMS-220;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
