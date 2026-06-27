{
  layer = "SMS";
  traceId = "FS-580-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-580-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-580-HDS-010-SDS-010-SMS-020-direct-public-dns-policy-gate.md";
  titleSlug = "direct-public-dns-policy-gate";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-580-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-580-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
