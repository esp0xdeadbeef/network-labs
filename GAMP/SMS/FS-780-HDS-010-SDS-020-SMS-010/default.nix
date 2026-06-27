{
  layer = "SMS";
  traceId = "FS-780-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-780-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-780-HDS-010-SDS-020-SMS-010-equivalence-atom-contract.md";
  titleSlug = "equivalence-atom-contract";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-780-HDS-010-SDS-020-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-780-HDS-010-SDS-020-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
