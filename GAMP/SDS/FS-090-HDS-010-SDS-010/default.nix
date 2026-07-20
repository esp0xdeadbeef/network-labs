{
  layer = "SDS";
  traceId = "FS-090-HDS-010-SDS-010";
  purpose = "No-downstream-heuristic-repair active-lab input grouping.";
  smsInputs = {
    "FS-090-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-090-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "FS-090-HDS-010-SDS-010-SMS-010" ];
      inputKinds = [ "intent-source" "runtime-active-lab" ];
      evidenceBoundary = "runtime";
    };
  };
}
