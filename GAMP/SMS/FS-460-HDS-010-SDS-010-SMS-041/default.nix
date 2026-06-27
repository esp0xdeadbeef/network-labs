{
  layer = "SMS";
  traceId = "FS-460-HDS-010-SDS-010-SMS-041";
  parentSds = ../../SDS/FS-460-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-460-HDS-010-SDS-010-SMS-041-nebula-fail-closed-contract.md";
  titleSlug = "nebula-fail-closed-contract";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-460-HDS-010-SDS-010-SMS-041";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-041/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
