{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-906";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Controlled Nebula canonical-input construction scenario.";
  evidenceBoundary = "construction-only until a fresh cold stage is recorded";
  sourceInputs."FS-166-HDS-010-SDS-010-SMS-906" = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-906";
    kind = "replacement-cpm-artifact";
    rendererTarget = "nebula";
    sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-906.sourceArtifact";
    firstActiveBoundary = "network-realization-model";
    maxRuntimeTargets = 2;
  };
}
