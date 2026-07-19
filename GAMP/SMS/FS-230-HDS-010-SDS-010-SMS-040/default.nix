{
  layer = "SMS";
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-230-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md";
  titleSlug = "s-router-prod-nebula-ipv6-ingress-compatibility";
  purpose = "Canonical SMS mirror with an isolated intent/inventory construction candidate.";
  evidenceBoundary = "construction-source-only-live-pending";
  sourceInputs = {
    "native-protected-ipv6-ingress" = {
      traceId = "FS-230-HDS-010-SDS-010-SMS-040";
      kind = "intent-and-inventory-source";
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix";
      test = "tests/FS-230-HDS-010-SDS-010-SMS-040-native-protected-ipv6-ingress.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
    "tests/FS-230-HDS-010-SDS-010-SMS-040-native-protected-ipv6-ingress.sh"
  ];
}
