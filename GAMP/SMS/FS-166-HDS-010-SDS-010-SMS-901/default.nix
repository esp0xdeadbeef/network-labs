{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-901";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Controlled NixOS canonical-input construction scenario.";
  evidenceBoundary = "construction-only until a fresh cold stage is recorded";
  sourceInputs."FS-166-HDS-010-SDS-010-SMS-901" = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-901";
    kind = "replacement-cpm-artifact";
    rendererTarget = "nixos";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/nixos-single.nix";
    firstActiveBoundary = "network-realization-model";
    maxRuntimeTargets = 1;
  };
}
