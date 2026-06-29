{
  layer = "SMS";
  traceId = "FS-100-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-100-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-100-HDS-010-SDS-010-SMS-050-output-artifact-baseline-binding.md";
  titleSlug = "output-artifact-baseline-binding";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-100-HDS-010-SDS-010-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-050/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
