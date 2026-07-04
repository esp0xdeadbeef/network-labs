{
  layer = "SMS";
  traceId = "FS-165-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-165-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-165-HDS-010-SDS-010-SMS-030-downstream-contract-gap-diagnostic.md";
  titleSlug = "downstream-contract-gap-diagnostic";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-165-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-165-HDS-010-SDS-010-SMS-030/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
