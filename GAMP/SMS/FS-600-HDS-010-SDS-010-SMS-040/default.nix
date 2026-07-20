{
  layer = "SMS";
  traceId = "FS-600-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-600-HDS-010-SDS-010;
  purpose = "Discovery Follow-On Payload Denial Module (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-600-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-600-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
