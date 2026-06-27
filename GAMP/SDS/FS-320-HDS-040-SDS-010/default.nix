{
  layer = "SDS";
  traceId = "FS-320-HDS-040-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-320-HDS-040-SDS-010-SMS-060" = {
      smsRow = ../../SMS/FS-320-HDS-040-SDS-010-SMS-060;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
