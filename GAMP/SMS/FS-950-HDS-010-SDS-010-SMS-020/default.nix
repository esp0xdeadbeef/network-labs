{
  layer = "SMS";
  traceId = "FS-950-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-950-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-950-HDS-010-SDS-010-SMS-020-evidence-design-construction-routing.md";
  titleSlug = "evidence-design-construction-routing";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-950-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-950-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
