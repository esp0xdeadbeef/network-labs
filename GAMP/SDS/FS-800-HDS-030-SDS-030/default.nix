{
  layer = "SDS";
  traceId = "FS-800-HDS-030-SDS-030";
  purpose = "Active-lab PPPoE mini POC input grouping.";
  smsInputs = {
    "FS-800-HDS-030-SDS-030-SMS-010" = {
      smsRow = ../../SMS/FS-800-HDS-030-SDS-030-SMS-010;
      miniSmtIds = [ "FS-800-HDS-030-SDS-030-SMS-010" ];
      inputKinds = [ "intent-source" ];
    };
    "FS-800-HDS-030-SDS-030-SMS-040" = {
      smsRow = ../../SMS/FS-800-HDS-030-SDS-030-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
}
