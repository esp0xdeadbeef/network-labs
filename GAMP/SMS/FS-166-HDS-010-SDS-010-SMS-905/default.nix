{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-905";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Controlled WireGuard canonical-input construction scenario.";
  evidenceBoundary = "construction-only until a fresh cold stage is recorded";
  sourceInputs."FS-166-HDS-010-SDS-010-SMS-905" = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-905";
    kind = "replacement-cpm-artifact";
    rendererTarget = "wireguard";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/wireguard.nix";
    firstActiveBoundary = "network-realization-model";
    maxRuntimeTargets = 1;
  };
}
