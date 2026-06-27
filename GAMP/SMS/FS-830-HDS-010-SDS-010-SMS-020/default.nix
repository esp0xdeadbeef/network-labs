{
  layer = "SMS";
  traceId = "FS-830-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-830-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-830-HDS-010-SDS-010-SMS-020-protected-secret-cold-handling.md";
  titleSlug = "protected-secret-cold-handling";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-830-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-830-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
