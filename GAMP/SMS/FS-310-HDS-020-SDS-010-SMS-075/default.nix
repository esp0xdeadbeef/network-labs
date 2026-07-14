{
  layer = "SMS";
  traceId = "FS-310-HDS-020-SDS-010-SMS-075";
  parentSds = ../../SDS/FS-310-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-020-SDS-010-SMS-075-renderer-core-ingress-dnat-materialization.md";
  titleSlug = "renderer-core-ingress-dnat-materialization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-310-HDS-020-SDS-010-SMS-075";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-075/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
