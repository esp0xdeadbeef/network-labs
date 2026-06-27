{
  layer = "SMS";
  traceId = "FS-710-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-710-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-710-HDS-010-SDS-010-SMS-020-lab-site-provider-ingress-overlay.md";
  titleSlug = "lab-site-provider-ingress-overlay";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-710-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-710-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
