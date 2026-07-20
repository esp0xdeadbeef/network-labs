{
  layer = "SMS";
  traceId = "FS-760-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-760-HDS-010-SDS-010;
  purpose = "Receiver Tenant And Management Denial (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-760-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
