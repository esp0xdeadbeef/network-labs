{
  layer = "SMS";
  traceId = "FS-800-HDS-010-SDS-013-SMS-020";
  parentSds = ../../SDS/FS-800-HDS-010-SDS-013;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-013-SMS-020-cpm-provider-handoff-fabric-egress.md";
  titleSlug = "cpm-provider-handoff-fabric-egress";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-800-HDS-010-SDS-013-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-013-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
