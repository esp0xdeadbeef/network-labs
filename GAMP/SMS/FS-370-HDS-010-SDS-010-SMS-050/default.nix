{
  layer = "SMS";
  traceId = "FS-370-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-370-HDS-010-SDS-010;
  purpose = "Lane egress binding mini POC source input template.";
  sourceInputs = {
    "FS-370-HDS-010-SDS-010-SMS-050" = {
      traceId = "FS-370-HDS-010-SDS-010-SMS-050";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/intent.nix";
      maxRuntimeTargets = 2;
    };
  };
}
