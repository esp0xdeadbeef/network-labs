let
  traceIds = [
    "FS-166-HDS-010-SDS-010-SMS-010"
    "FS-166-HDS-010-SDS-010-SMS-020"
    "FS-166-HDS-010-SDS-010-SMS-030"
    "FS-166-HDS-010-SDS-010-SMS-900"
    "FS-166-HDS-010-SDS-010-SMS-901"
    "FS-166-HDS-010-SDS-010-SMS-902"
    "FS-166-HDS-010-SDS-010-SMS-903"
    "FS-166-HDS-010-SDS-010-SMS-904"
    "FS-166-HDS-010-SDS-010-SMS-905"
    "FS-166-HDS-010-SDS-010-SMS-906"
  ];
in
{
  layer = "SDS";
  traceId = "FS-166-HDS-010-SDS-010";
  purpose = "Controlled layer-entry acknowledgement, orchestration, evidence, and replacement-scenario grouping.";
  smsInputs = builtins.listToAttrs (
    map (traceId: {
      name = traceId;
      value = {
        smsRow = ../../SMS + "/${traceId}";
        miniSmtIds = [ traceId ];
        inputKinds = [ "controlled-layer-entry" ];
      };
    }) traceIds
  );
}
