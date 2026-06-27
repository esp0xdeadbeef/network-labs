{
  layer = "SMS";
  traceId = "FS-720-HDS-010-SDS-020-SMS-020";
  parentSds = ../../SDS/FS-720-HDS-010-SDS-020;
  purpose = "Endpoint harness consumption mini POC source input template.";
  sourceInputs = {
    endpoint-harness-consumption = {
      traceId = "FS-720-HDS-010-SDS-020-SMS-020";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-020/intent.nix";
      test = "tests/test-active-lab-mini-smt-endpoint-harness-consumption-only.sh";
      maxRuntimeTargets = 3;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
