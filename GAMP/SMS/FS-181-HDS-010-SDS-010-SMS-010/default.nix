{
  layer = "SMS";
  traceId = "FS-181-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-181-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-181-HDS-010-SDS-010-SMS-010-graph-path-mapping-authority.md";
  titleSlug = "graph-path-mapping-authority";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-181-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-181-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
