{
  layer = "SMS";
  traceId = "FS-800-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-800-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-010-SMS-020-provider-access-canonical-stage-topology.md";
  titleSlug = "provider-access-canonical-stage-topology";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-800-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
