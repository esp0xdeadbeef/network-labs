{
  layer = "SMS";
  traceId = "FS-470-HDS-010-SDS-010-SMS-080";
  parentSds = ../../SDS/FS-470-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-080-wireguard-policy-boundary.md";
  titleSlug = "wireguard-policy-boundary";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-470-HDS-010-SDS-010-SMS-080";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-080/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
