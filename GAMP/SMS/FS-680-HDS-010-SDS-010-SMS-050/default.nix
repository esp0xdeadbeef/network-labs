{
  layer = "SMS";
  traceId = "FS-680-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-680-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-680-HDS-010-SDS-010-SMS-050-shared-service-denial-management.md";
  titleSlug = "shared-service-denial-management";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-680-HDS-010-SDS-010-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-680-HDS-010-SDS-010-SMS-050/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
