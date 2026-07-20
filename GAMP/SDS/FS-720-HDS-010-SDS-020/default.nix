{
  layer = "SDS";
  traceId = "FS-720-HDS-010-SDS-020";
  purpose = "Endpoint harness consumption mini POC input grouping.";
  smsInputs = {
    "FS-720-HDS-010-SDS-020-SMS-020" = {
      smsRow = ../../SMS/FS-720-HDS-010-SDS-020-SMS-020;
      miniSmtIds = [ "endpoint-harness-consumption" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "construction-only";
    };
    "FS-720-HDS-010-SDS-020-SMS-040" = {
      smsRow = ../../SMS/FS-720-HDS-010-SDS-020-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
}
