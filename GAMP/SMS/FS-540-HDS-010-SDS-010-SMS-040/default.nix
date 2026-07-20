{
  layer = "SMS";
  traceId = "FS-540-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-540-HDS-010-SDS-010;
  purpose = "Requester Lane Recursive Reachability Module (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-540-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
