{
  layer = "SMS";
  traceId = "FS-500-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-500-HDS-010-SDS-010;
  purpose = "Point-to-point next-hop mini POC source input template.";
  sourceInputs = {
    "FS-500-HDS-010-SDS-010-SMS-040" = {
      traceId = "FS-500-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 2;
    };
  };
}
