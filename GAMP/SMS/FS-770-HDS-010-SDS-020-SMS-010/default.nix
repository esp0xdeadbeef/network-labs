{
  layer = "SMS";
  traceId = "FS-770-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-770-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-020-SMS-010-realization-fact-binding.md";
  titleSlug = "realization-fact-binding";
  purpose = "Focused common behavior source binding construction input.";
  evidenceBoundary = "focused-construction";
  sourceInputs = {
    "common-behavior-source-binding" = {
      traceId = "FS-770-HDS-010-SDS-020-SMS-010";
      kind = "hat-inventory-source-binding";
      sourcePath = "GAMP/HAT/emulated-isp-residential-testnet/common-behavior-source-binding.nix";
      test = "tests/test-fs770-hds010-sds020-sms010-realization-fact-binding.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-fs770-hds010-sds020-sms010-realization-fact-binding.sh"
  ];
}
