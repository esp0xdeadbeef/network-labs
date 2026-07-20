{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-901";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-901;
  source = {
    kind = "replacement-cpm-artifact";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nixos-single.nix";
    firstActiveBoundary = "network-realization-model";
    rendererTarget = "nixos";
    expectedTargetNames = [ "poc-router" ];
  };
  status = "NOT OK";
  evidence = {
    constructionStatus = "OK";
    liveStatus = "NOT OK";
  };
}
