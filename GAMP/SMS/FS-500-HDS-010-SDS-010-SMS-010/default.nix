{
  layer = "SMS";
  traceId = "FS-500-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-500-HDS-010-SDS-010;
  purpose = "Reachability decision result mini POC source input template.";
  sourceInputs = {
    "FS-500-HDS-010-SDS-010-SMS-010" = {
      traceId = "FS-500-HDS-010-SDS-010-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-active-lab-mini-smt-reachability-decision-only.sh";
      maxRuntimeTargets = 2;
    };
  };
  templateTests = [
    "tests/test-gamp-row-source-stubs.sh"
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
