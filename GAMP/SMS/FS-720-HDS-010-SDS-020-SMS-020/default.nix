{
  layer = "SMS";
  traceId = "FS-720-HDS-010-SDS-020-SMS-020";
  parentSds = ../../SDS/FS-720-HDS-010-SDS-020;
  purpose = "Endpoint harness consumption mini POC source input template.";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    endpoint-harness-consumption = {
      traceId = "FS-720-HDS-010-SDS-020-SMS-020";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-020/intent.nix";
      maxRuntimeTargets = 3;
    };
  };
}
