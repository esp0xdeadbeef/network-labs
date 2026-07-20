{
  layer = "SMS";
  traceId = "FS-570-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-570-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-570-HDS-010-SDS-010-SMS-020-split-horizon-fallback-binding.md";
  titleSlug = "split-horizon-fallback-binding";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-570-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-570-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
