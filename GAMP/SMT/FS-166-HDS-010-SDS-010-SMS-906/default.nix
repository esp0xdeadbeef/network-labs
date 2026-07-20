{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-906";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-906;
  source = {
    kind = "replacement-cpm-artifact";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nebula.nix";
    firstActiveBoundary = "network-realization-model";
    rendererTarget = "nebula";
    expectedTargetNames = [
      "lab-client-nebula"
      "lab-lighthouse"
    ];
  };
  status = "NOT OK";
  evidence = {
    constructionStatus = "OK";
    liveStatus = "NOT OK";
  };
}
