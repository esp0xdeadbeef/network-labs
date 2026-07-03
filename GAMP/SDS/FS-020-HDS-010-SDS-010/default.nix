{
  layer = "SDS";
  traceId = "FS-020-HDS-010-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-020-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-020-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "FS-020-HDS-010-SDS-010-SMS-010" ];
      inputKinds = [ "intent-source" "live-artifact-source" ];
      evidenceBoundary = "row-local-mini-smt";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
