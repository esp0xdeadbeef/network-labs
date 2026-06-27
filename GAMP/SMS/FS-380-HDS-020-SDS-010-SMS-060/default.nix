{
  layer = "SMS";
  traceId = "FS-380-HDS-020-SDS-010-SMS-060";
  parentSds = ../../SDS/FS-380-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-020-SDS-010-SMS-060-core-wan-ip-assignment.md";
  titleSlug = "core-wan-ip-assignment";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-380-HDS-020-SDS-010-SMS-060";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-060/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
