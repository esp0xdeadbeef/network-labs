{
  layer = "SMS";
  traceId = "FS-800-HDS-010-SDS-020-SMS-040";
  parentSds = ../../SDS/FS-800-HDS-010-SDS-020;
  purpose = "Provider-access fabric gateway routing mini POC source input template.";
  sourceInputs = {
    provider-access-default-route = {
      traceId = "FS-800-HDS-010-SDS-020-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix";
      test = "tests/test-active-lab-mini-smt-provider-access-default-route.sh";
      maxRuntimeTargets = 3;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
