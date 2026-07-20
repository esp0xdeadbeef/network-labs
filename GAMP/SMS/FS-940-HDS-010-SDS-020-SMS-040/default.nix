{
  layer = "SMS";
  traceId = "FS-940-HDS-010-SDS-020-SMS-040";
  parentSds = ../../SDS/FS-940-HDS-010-SDS-020;
  purpose = "Next-Hop Equivalence Table (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-940-HDS-010-SDS-020-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
