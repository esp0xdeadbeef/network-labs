{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-010;
  purpose = "CPM Binder Source Audit (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-030-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
