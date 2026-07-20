{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-905";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-905;
  source = {
    kind = "replacement-cpm-artifact";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/wireguard.nix";
    firstActiveBoundary = "network-realization-model";
    rendererTarget = "wireguard";
    expectedTargetNames = [ "wireguard-egress" ];
  };
  status = "NOT OK";
  evidence = {
    constructionStatus = "OK";
    liveStatus = "NOT OK";
  };
}
