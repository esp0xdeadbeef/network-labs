{
  layer = "SDS";
  traceId = "FS-030-HDS-010-SDS-030";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-030-HDS-010-SDS-030-SMS-010" = {
      smsRow = ../../SMS/FS-030-HDS-010-SDS-030-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
