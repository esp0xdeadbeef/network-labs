{
  layer = "SMS";
  traceId = "FS-710-HDS-020-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-710-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-710-HDS-020-SDS-010-SMS-010-profile-realization-role-boundary.md";
  titleSlug = "profile-realization-role-boundary";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-710-HDS-020-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-710-HDS-020-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
