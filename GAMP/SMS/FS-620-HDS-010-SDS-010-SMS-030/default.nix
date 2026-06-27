{
  layer = "SMS";
  traceId = "FS-620-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-620-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-620-HDS-010-SDS-010-SMS-030-underlay-authority-rejection.md";
  titleSlug = "underlay-authority-rejection";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-620-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-620-HDS-010-SDS-010-SMS-030/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
