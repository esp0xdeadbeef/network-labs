{
  layer = "SMS";
  traceId = "FS-800-HDS-030-SDS-030-SMS-040";
  parentSds = ../../SDS/FS-800-HDS-030-SDS-030;
  purpose = "Row-local SMT/SIT source stub for FS-800-HDS-030-SDS-030-SMS-040.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-800-HDS-030-SDS-030-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
