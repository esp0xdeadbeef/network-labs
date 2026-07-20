{
  layer = "SDS";
  traceId = "FS-400-HDS-010-SDS-010";
  purpose = "ULA NAT66 selection mini POC input grouping.";
  smsInputs = {
    "FS-400-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-400-HDS-010-SDS-010-SMS-020;
      miniSmtIds = [ "ula-nat66-selection" ];
      inputKinds = [ "intent-source" ];
    };
    "FS-400-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-400-HDS-010-SDS-010-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
}
