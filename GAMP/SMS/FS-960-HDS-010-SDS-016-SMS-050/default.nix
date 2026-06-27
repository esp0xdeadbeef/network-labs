{
  layer = "SMS";
  traceId = "FS-960-HDS-010-SDS-016-SMS-050";
  parentSds = ../../SDS/FS-960-HDS-010-SDS-016;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-960-HDS-010-SDS-016-SMS-050-clab-privileged-inspect.md";
  titleSlug = "clab-privileged-inspect";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-960-HDS-010-SDS-016-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-960-HDS-010-SDS-016-SMS-050/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
