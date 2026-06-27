{
  layer = "SMS";
  traceId = "FS-570-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-570-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-570-HDS-010-SDS-010-SMS-030-public-recursion-fallback-denial.md";
  titleSlug = "public-recursion-fallback-denial";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-570-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-570-HDS-010-SDS-010-SMS-030/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
