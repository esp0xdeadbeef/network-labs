{
  layer = "SMS";
  traceId = "FS-670-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-670-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-670-HDS-010-SDS-010-SMS-020-tenant-internet-resolver.md";
  titleSlug = "tenant-internet-resolver";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-670-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-670-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
