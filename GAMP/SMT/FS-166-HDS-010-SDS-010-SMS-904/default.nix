{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-904";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-904;
  source = {
    kind = "replacement-cpm-artifact";
    sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-904.sourceArtifact";
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
