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
      test = "tests/test-fs310-hds010-sds010-sms030-policy-router-relation-identity-row-local.sh";
      maxRuntimeTargets = 2;
    };
  };
  templateTests = [
    "tests/test-gamp-row-source-stubs.sh"
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
