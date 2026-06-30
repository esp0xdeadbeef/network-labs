{
  layer = "SMS";
  traceId = "FS-540-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-540-HDS-010-SDS-010;
  purpose = "DNS resolver config mini POC source input template.";
  sourceInputs = {
    "FS-540-HDS-010-SDS-010-SMS-020" = {
      traceId = "FS-540-HDS-010-SDS-010-SMS-020";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-active-lab-mini-smt-dns-resolver-config-only.sh";
      maxRuntimeTargets = 2;
    };
  };
  templateTests = [
    "tests/test-gamp-row-source-stubs.sh"
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
