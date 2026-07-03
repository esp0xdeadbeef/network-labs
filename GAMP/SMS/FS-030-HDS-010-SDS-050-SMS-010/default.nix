{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-050-SMS-010";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-050;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md";
  titleSlug = "core-role-boundary";
  purpose = "Core role boundary mini-SMT source and construction evidence template.";
  evidenceBoundary = "construction-plus-live-artifact";
  sourceInputs = {
    "FS-030-HDS-010-SDS-050-SMS-010" = {
      traceId = "FS-030-HDS-010-SDS-050-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/intent.nix";
      test = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh";
      maxRuntimeTargets = 5;
    };
    "canonical-source-stub" = {
      traceId = "FS-030-HDS-010-SDS-050-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh"
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
