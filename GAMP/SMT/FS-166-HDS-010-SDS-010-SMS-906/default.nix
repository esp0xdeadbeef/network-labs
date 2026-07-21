{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-906";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-906;
  source = {
    kind = "replacement-cpm-artifact";
    sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-906.sourceArtifact";
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
