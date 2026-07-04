{
  layer = "SDS";
  traceId = "FS-040-HDS-010-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-040-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-040-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "FS-040-HDS-010-SDS-010-SMS-010" ];
      inputKinds = [
        "intent-source"
        "nixos-inventory"
        "clab-inventory"
        "test-client-inventory"
      ];
      evidenceBoundary = "construction-plus-live-active-lab-artifact";
    };
  };
  templateTests = [
    "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/test.sh"
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
