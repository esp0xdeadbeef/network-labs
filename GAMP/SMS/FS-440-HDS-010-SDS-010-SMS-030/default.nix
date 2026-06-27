{
  layer = "SMS";
  traceId = "FS-440-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-440-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-440-HDS-010-SDS-010-SMS-030-provider-endpoint-host-only-classification.md";
  titleSlug = "provider-endpoint-host-only-classification";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-440-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-440-HDS-010-SDS-010-SMS-030/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
