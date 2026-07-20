{
  layer = "SMS";
  traceId = "FS-510-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-510-HDS-010-SDS-010;
  purpose = "External Ingress Point-To-Point Pairing Module (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-510-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-510-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
