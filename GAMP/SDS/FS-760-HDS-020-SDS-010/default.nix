{
  layer = "SDS";
  traceId = "FS-760-HDS-020-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-760-HDS-020-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-760-HDS-020-SDS-010-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
