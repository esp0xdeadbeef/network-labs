{
  layer = "SDS";
  traceId = "FS-780-HDS-010-SDS-020";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-780-HDS-010-SDS-020-SMS-010" = {
      smsRow = ../../SMS/FS-780-HDS-010-SDS-020-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-780-HDS-010-SDS-020-SMS-020" = {
      smsRow = ../../SMS/FS-780-HDS-010-SDS-020-SMS-020;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
