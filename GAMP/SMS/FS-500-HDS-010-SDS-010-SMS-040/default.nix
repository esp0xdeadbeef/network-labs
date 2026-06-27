{
  layer = "SMS";
  traceId = "FS-500-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-500-HDS-010-SDS-010;
  purpose = "Point-to-point next-hop mini POC source input template.";
  sourceInputs = {
    p2p-next-hop = {
      traceId = "FS-500-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix";
      test = "tests/test-active-lab-mini-smt-p2p-next-hop-only.sh";
      maxRuntimeTargets = 2;
    };
  };
  templateTests = [
    "tests/test-gamp-row-source-stubs.sh"
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
