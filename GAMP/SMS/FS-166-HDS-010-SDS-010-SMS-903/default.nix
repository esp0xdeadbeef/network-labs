{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-903";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Controlled access-endpoint canonical-input construction scenario.";
  evidenceBoundary = "construction-only until a fresh cold stage is recorded";
  sourceInputs."FS-166-HDS-010-SDS-010-SMS-903" = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-903";
    kind = "replacement-cpm-artifact";
    rendererTarget = "access-endpoint-nixos";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/access-endpoint.nix";
    firstActiveBoundary = "network-realization-model";
    maxRuntimeTargets = 1;
  };
}
