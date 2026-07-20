{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-904";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-904;
  source = {
    kind = "replacement-cpm-artifact";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/clab-p2p.nix";
    firstActiveBoundary = "network-realization-model";
    rendererTarget = "clab";
    expectedTargetNames = [
      "edge-a"
      "edge-b"
    ];
  };
  status = "NOT OK";
  evidence = {
    constructionStatus = "OK";
    liveStatus = "NOT OK";
  };
}
