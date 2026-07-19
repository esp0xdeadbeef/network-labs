{
  layer = "SDS";
  traceId = "FS-230-HDS-010-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-230-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-230-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-230-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-230-HDS-010-SDS-010-SMS-020;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-230-HDS-010-SDS-010-SMS-030" = {
      smsRow = ../../SMS/FS-230-HDS-010-SDS-010-SMS-030;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-230-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-230-HDS-010-SDS-010-SMS-040;
      miniSmtIds = [ "native-protected-ipv6-ingress" ];
      inputKinds = [ "intent-and-inventory-source" ];
      evidenceBoundary = "construction-source-only-live-pending";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
    "tests/FS-230-HDS-010-SDS-010-SMS-040-native-protected-ipv6-ingress.sh"
  ];
}
