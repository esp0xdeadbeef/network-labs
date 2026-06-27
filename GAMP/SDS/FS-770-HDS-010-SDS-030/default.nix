{
  layer = "SDS";
  traceId = "FS-770-HDS-010-SDS-030";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-770-HDS-010-SDS-030-SMS-010" = {
      smsRow = ../../SMS/FS-770-HDS-010-SDS-030-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-770-HDS-010-SDS-030-SMS-020" = {
      smsRow = ../../SMS/FS-770-HDS-010-SDS-030-SMS-020;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-770-HDS-010-SDS-030-SMS-030" = {
      smsRow = ../../SMS/FS-770-HDS-010-SDS-030-SMS-030;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
