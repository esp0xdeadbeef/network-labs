{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-902";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Controlled NixOS point-to-point canonical-input construction scenario.";
  evidenceBoundary = "construction-only until a fresh cold stage is recorded";
  sourceInputs."FS-166-HDS-010-SDS-010-SMS-902" = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-902";
    kind = "replacement-cpm-artifact";
    rendererTarget = "nixos";
    sourceReference = "validation-scheme:scenarioDefinitions.FS-166-HDS-010-SDS-010-SMS-902.sourceArtifact";
    firstActiveBoundary = "network-realization-model";
    maxRuntimeTargets = 2;
  };
}
