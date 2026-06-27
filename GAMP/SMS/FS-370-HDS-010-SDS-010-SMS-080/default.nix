{
  layer = "SMS";
  traceId = "FS-370-HDS-010-SDS-010-SMS-080";
  parentSds = ../../SDS/FS-370-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-080-upstream-selector-default-route.md";
  titleSlug = "upstream-selector-default-route";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-370-HDS-010-SDS-010-SMS-080";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-080/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
