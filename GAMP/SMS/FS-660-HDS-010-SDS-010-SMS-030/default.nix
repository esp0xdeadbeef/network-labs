{
  layer = "SMS";
  traceId = "FS-660-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-660-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-660-HDS-010-SDS-010-SMS-030-access-space-resolver-discovery.md";
  titleSlug = "access-space-resolver-discovery";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-660-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-660-HDS-010-SDS-010-SMS-030/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
