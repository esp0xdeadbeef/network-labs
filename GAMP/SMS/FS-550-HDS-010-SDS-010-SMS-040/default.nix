{
  layer = "SMS";
  traceId = "FS-550-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-550-HDS-010-SDS-010;
  purpose = "Modeled DNS Failure Behavior Module (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-550-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-550-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
