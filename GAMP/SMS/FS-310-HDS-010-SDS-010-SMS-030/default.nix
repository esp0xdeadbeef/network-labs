{
  layer = "SMS";
  traceId = "FS-310-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-310-HDS-010-SDS-010;
  purpose = "Policy router relation identity mini POC source input template.";
  sourceInputs = {
    policy-router-relation-identity = {
      traceId = "FS-310-HDS-010-SDS-010-SMS-030";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 2;
    };
  };
}
