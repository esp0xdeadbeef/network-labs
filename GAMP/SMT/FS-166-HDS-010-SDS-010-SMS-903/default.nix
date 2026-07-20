{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-903";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-903;
  source = {
    kind = "replacement-cpm-artifact";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/access-endpoint.nix";
    firstActiveBoundary = "network-realization-model";
    rendererTarget = "access-endpoint-nixos";
    expectedTargetNames = [ "poc-client" ];
  };
  status = "NOT OK";
  evidence = {
    constructionStatus = "OK";
    liveStatus = "NOT OK";
  };
}
