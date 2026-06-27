{
  layer = "SMS";
  traceId = "FS-610-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-610-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-610-HDS-010-SDS-010-SMS-020-discovery-boundary-decision-separation.md";
  titleSlug = "discovery-boundary-decision-separation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-610-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-610-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
