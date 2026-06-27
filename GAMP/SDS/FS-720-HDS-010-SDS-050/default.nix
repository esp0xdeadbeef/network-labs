{
  layer = "SDS";
  traceId = "FS-720-HDS-010-SDS-050";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-720-HDS-010-SDS-050-SMS-010" = {
      smsRow = ../../SMS/FS-720-HDS-010-SDS-050-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
