{
  layer = "SMS";
  traceId = "FS-880-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-880-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-880-HDS-010-SDS-010-SMS-020-namespace-conflict-state-predicates.md";
  titleSlug = "namespace-conflict-state-predicates";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-880-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-880-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
