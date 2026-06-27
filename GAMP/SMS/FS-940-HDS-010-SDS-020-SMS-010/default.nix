{
  layer = "SMS";
  traceId = "FS-940-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-940-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-940-HDS-010-SDS-020-SMS-010-shared-route-group-planner.md";
  titleSlug = "shared-route-group-planner";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-940-HDS-010-SDS-020-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
