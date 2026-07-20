{
  layer = "SMS";
  traceId = "FS-920-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-920-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-920-HDS-010-SDS-010-SMS-020-failure-response-binding.md";
  titleSlug = "failure-response-binding";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-920-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-920-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
