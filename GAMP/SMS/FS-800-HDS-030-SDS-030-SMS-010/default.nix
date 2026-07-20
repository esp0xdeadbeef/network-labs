{
  layer = "SMS";
  traceId = "FS-800-HDS-030-SDS-030-SMS-010";
  parentSds = ../../SDS/FS-800-HDS-030-SDS-030;
  purpose = "PPPoE provider/customer pairing mini POC source input template.";
  sourceInputs = {
    "FS-800-HDS-030-SDS-030-SMS-010" = {
      traceId = "FS-800-HDS-030-SDS-030-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-010/intent.nix";
      maxRuntimeTargets = 2;
    };
  };
}
