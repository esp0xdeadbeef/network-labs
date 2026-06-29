{
  layer = "SMS";
  traceId = "FS-310-HDS-020-SDS-010-SMS-200";
  parentSds = ../../SDS/FS-310-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-020-SDS-010-SMS-200-renderer-bridge-network-no-default-contract.md";
  titleSlug = "renderer-bridge-network-no-default-contract";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-310-HDS-020-SDS-010-SMS-200";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-200/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
