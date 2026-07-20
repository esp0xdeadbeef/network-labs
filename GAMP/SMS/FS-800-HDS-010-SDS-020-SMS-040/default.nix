{
  layer = "SMS";
  traceId = "FS-800-HDS-010-SDS-020-SMS-040";
  parentSds = ../../SDS/FS-800-HDS-010-SDS-020;
  purpose = "Provider-access fabric gateway routing mini POC source input template.";
  sourceInputs = {
    "FS-800-HDS-010-SDS-020-SMS-040" = {
      traceId = "FS-800-HDS-010-SDS-020-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix";
      maxRuntimeTargets = 3;
    };
  };
}
