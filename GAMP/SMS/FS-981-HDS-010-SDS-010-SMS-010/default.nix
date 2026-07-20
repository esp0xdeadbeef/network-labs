{
  layer = "SMS";
  traceId = "FS-981-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-981-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-981-HDS-010-SDS-010-SMS-010-dead-code-test-target-hygiene.md";
  titleSlug = "dead-code-test-target-hygiene";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-981-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-981-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
