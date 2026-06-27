{
  layer = "SMS";
  traceId = "FS-500-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-500-HDS-010-SDS-010;
  purpose = "Decision reason diagnostic mini POC source input template.";
  sourceInputs = {
    decision-reason-diagnostic = {
      traceId = "FS-500-HDS-010-SDS-010-SMS-030";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-030/intent.nix";
      test = "tests/test-active-lab-mini-smt-decision-reason-diagnostic-only.sh";
      maxRuntimeTargets = 2;
    };
  };
  templateTests = [
    "tests/test-gamp-row-source-stubs.sh"
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
