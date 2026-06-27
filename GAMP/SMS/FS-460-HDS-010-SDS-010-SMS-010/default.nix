{
  layer = "SMS";
  traceId = "FS-460-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-460-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-460-HDS-010-SDS-010-SMS-010-nebula-remote-egress.md";
  titleSlug = "nebula-remote-egress";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-460-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
