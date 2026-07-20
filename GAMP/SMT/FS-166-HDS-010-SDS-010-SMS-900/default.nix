let
  sms = import ../../SMS/FS-166-HDS-010-SDS-010-SMS-900/default.nix;
in
{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-900";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
  sitRow = ../../SIT/FS-166-HDS-010-SDS-010;
  evidenceBoundary = "construction-only";
  source = null;
  purpose = "Controlled replacement-CPM source map for six canonical renderer construction scenarios.";
  evidence = {
    owningRepo = "network-labs";
    constructionStatus = "OK";
    liveStatus = "NOT OK";
    scope = "Construction validates controlled skip acknowledgements, one replacement injection, realization, schema release, one normalized binding bundle, and canonical renderer input. Child rows own fresh cold-stage runtime evidence.";
  };
  inherit (sms) sourceInputs;
}
