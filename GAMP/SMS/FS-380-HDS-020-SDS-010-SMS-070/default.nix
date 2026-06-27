{
  layer = "SMS";
  traceId = "FS-380-HDS-020-SDS-010-SMS-070";
  parentSds = ../../SDS/FS-380-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-020-SDS-010-SMS-070-egress-path-priority.md";
  titleSlug = "egress-path-priority";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-380-HDS-020-SDS-010-SMS-070";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-070/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
