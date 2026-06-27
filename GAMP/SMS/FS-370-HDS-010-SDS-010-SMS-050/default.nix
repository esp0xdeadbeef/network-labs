{
  layer = "SMS";
  traceId = "FS-370-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-370-HDS-010-SDS-010;
  purpose = "Lane egress binding mini POC source input template.";
  sourceInputs = {
    lane-egress-binding = {
      traceId = "FS-370-HDS-010-SDS-010-SMS-050";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/intent.nix";
      test = "tests/test-active-lab-mini-smt-lane-egress-binding-only.sh";
      maxRuntimeTargets = 2;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
