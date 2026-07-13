{
  layer = "SMS";
  traceId = "FS-970-HDS-010-SDS-020-SMS-040";
  parentSds = ../../SDS/FS-970-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md";
  titleSlug = "runtime-secret-reservation-materialization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-970-HDS-010-SDS-020-SMS-040";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-040/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
