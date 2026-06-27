{
  layer = "SMS";
  traceId = "FS-760-HDS-030-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-760-HDS-030-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-760-HDS-030-SDS-010-SMS-010-receiver-payload-reverse-surfaces.md";
  titleSlug = "receiver-payload-reverse-surfaces";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-760-HDS-030-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-760-HDS-030-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
