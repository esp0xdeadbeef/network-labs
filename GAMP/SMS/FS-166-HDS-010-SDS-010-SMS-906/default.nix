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
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nebula.nix";
    firstActiveBoundary = "network-realization-model";
    maxRuntimeTargets = 2;
  };
}
