{
  layer = "SMS";
  traceId = "FS-380-HDS-020-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-380-HDS-020-SDS-010;
  purpose = "Internet mode verification mini POC source input template.";
  sourceInputs = {
    "FS-380-HDS-020-SDS-010-SMS-050" = {
      traceId = "FS-380-HDS-020-SDS-010-SMS-050";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-050/intent.nix";
      test = "tests/test-active-lab-mini-smt-internet-mode-verification-only.sh";
      maxRuntimeTargets = 2;
    };
  };
  templateTests = [
    "tests/test-gamp-row-source-stubs.sh"
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
