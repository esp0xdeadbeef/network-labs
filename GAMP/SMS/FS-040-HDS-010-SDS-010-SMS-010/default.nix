{
  layer = "SMS";
  traceId = "FS-040-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-040-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md";
  titleSlug = "public-inventory-boundary";
  purpose = "Active-lab public-inventory boundary source and evidence template.";
  evidenceBoundary = "construction-plus-live-active-lab-artifact";
  sourceInputs = {
    "FS-040-HDS-010-SDS-010-SMS-010" = {
      traceId = "FS-040-HDS-010-SDS-010-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "network-codex-agent/scripts/smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh";
      maxRuntimeTargets = 5;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
