{
  layer = "SMS";
  traceId = "FS-500-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-500-HDS-010-SDS-010;
  purpose = "Decision reason diagnostic mini POC source input template.";
  sourceInputs = {
    "FS-500-HDS-010-SDS-010-SMS-030" = {
      traceId = "FS-500-HDS-010-SDS-010-SMS-030";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 2;
    };
  };
}
