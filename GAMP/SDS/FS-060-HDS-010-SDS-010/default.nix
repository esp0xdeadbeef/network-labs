{
  layer = "SDS";
  traceId = "FS-060-HDS-010-SDS-010";
  purpose = "Runtime fact boundary active-lab input grouping.";
  smsInputs = {
    "FS-060-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-060-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "FS-060-HDS-010-SDS-010-SMS-010" ];
      inputKinds = [ "intent-source" "runtime-active-lab" ];
      evidenceBoundary = "runtime";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
