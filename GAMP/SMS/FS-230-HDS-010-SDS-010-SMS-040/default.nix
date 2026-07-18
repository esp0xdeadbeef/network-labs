{
  layer = "SMS";
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-230-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md";
  titleSlug = "s-router-prod-nebula-ipv6-ingress-compatibility";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-230-HDS-010-SDS-010-SMS-040";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
