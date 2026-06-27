{
  layer = "SMS";
  traceId = "FS-960-HDS-010-SDS-010-SMS-070";
  parentSds = ../../SDS/FS-960-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-960-HDS-010-SDS-010-SMS-070-clab-autostart-cache-privileged-readiness.md";
  titleSlug = "clab-autostart-cache-privileged-readiness";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-960-HDS-010-SDS-010-SMS-070";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-960-HDS-010-SDS-010-SMS-070/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
