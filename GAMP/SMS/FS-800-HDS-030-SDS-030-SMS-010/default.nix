{
  layer = "SMS";
  traceId = "FS-800-HDS-030-SDS-030-SMS-010";
  parentSds = ../../SDS/FS-800-HDS-030-SDS-030;
  purpose = "PPPoE provider/customer pairing mini POC source input template.";
  sourceInputs = {
    pppoe-pairing = {
      traceId = "FS-800-HDS-030-SDS-030-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-010/intent.nix";
      test = "tests/test-active-lab-mini-smt-pppoe-pairing-only.sh";
      maxRuntimeTargets = 2;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
