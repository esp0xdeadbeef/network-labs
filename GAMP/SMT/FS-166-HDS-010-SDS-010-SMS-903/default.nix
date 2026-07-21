{
  layer = "SMT";
  traceId = "FS-166-HDS-010-SDS-010-SMS-903";
  smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-903;
  source = {
    kind = "replacement-cpm-artifact";
    sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-903.sourceArtifact";
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
