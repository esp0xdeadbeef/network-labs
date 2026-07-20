{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-904";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Controlled Containerlab canonical-input construction scenario.";
  evidenceBoundary = "construction-only until a fresh cold stage is recorded";
  sourceInputs."FS-166-HDS-010-SDS-010-SMS-904" = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-904";
    kind = "replacement-cpm-artifact";
    rendererTarget = "clab";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/replacement-artifacts/clab-p2p.nix";
    firstActiveBoundary = "network-realization-model";
    maxRuntimeTargets = 2;
  };
}
