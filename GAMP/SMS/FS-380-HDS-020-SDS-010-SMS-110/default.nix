{
  layer = "SMS";
  traceId = "FS-380-HDS-020-SDS-010-SMS-110";
  parentSds = ../../SDS/FS-380-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-020-SDS-010-SMS-110-cpm-dhcp-server-authority.md";
  titleSlug = "cpm-dhcp-server-authority";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-380-HDS-020-SDS-010-SMS-110";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-110/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
