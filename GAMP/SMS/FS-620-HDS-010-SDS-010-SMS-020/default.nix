{
  layer = "SMS";
  traceId = "FS-620-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-620-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-620-HDS-010-SDS-010-SMS-020-shared-service-exception-binding.md";
  titleSlug = "shared-service-exception-binding";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-620-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-620-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
