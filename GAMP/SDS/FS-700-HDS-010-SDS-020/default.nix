{
  layer = "SDS";
  traceId = "FS-700-HDS-010-SDS-020";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-700-HDS-010-SDS-020-SMS-010" = {
      smsRow = ../../SMS/FS-700-HDS-010-SDS-020-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
