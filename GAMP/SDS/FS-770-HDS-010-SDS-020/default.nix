{
  layer = "SDS";
  traceId = "FS-770-HDS-010-SDS-020";
  purpose = "FS-770-HDS-010-SDS-020 software design — construction-only validation chain.";
  smsInputs = {
    "FS-770-HDS-010-SDS-020-SMS-010" = {
      smsRow = ../../SMS/FS-770-HDS-010-SDS-020-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "hat-inventory-source-binding" ];
      evidenceBoundary = "focused-construction";
    };
    "FS-770-HDS-010-SDS-020-SMS-040" = {
      smsRow = ../../SMS/FS-770-HDS-010-SDS-020-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
}
