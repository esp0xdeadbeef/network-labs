{
  layer = "SMS";
  traceId = "FS-520-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-520-HDS-010-SDS-010;
  purpose = "Route Policy Separation — Policy Routes Shall Not Leak Into Main Table (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-520-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-520-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
