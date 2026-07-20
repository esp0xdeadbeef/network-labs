{
  layer = "SDS";
  traceId = "FS-070-HDS-010-SDS-010";
  purpose = "Validation-context boundary active-lab input grouping.";
  smsInputs = {
    "FS-070-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-070-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "FS-070-HDS-010-SDS-010-SMS-010" ];
      inputKinds = [ "intent-source" "runtime-active-lab" ];
      evidenceBoundary = "runtime";
    };
  };
}
