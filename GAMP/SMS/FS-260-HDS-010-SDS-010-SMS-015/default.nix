{
  layer = "SMS";
  traceId = "FS-260-HDS-010-SDS-010-SMS-015";
  parentSds = ../../SDS/FS-260-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-260-HDS-010-SDS-010-SMS-015-hat-policy-nft-rules-probe.md";
  titleSlug = "hat-policy-nft-rules-probe";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-260-HDS-010-SDS-010-SMS-015";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-015/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
