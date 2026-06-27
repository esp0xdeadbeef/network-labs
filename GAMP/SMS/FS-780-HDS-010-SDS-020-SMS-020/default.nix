{
  layer = "SMS";
  traceId = "FS-780-HDS-010-SDS-020-SMS-020";
  parentSds = ../../SDS/FS-780-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-780-HDS-010-SDS-020-SMS-020-equivalence-limitation-binding.md";
  titleSlug = "equivalence-limitation-binding";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-780-HDS-010-SDS-020-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-780-HDS-010-SDS-020-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
