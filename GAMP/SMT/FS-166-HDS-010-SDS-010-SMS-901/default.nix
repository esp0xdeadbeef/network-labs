{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-901";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-901;
  source = {
    kind = "replacement-cpm-artifact";
    sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-901.sourceArtifact";
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
