{
  layer = "SMS";
  traceId = "FS-260-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-260-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-260-HDS-010-SDS-010-SMS-020-core-to-core-overlay-fabric-chain.md";
  titleSlug = "core-to-core-overlay-fabric-chain";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-260-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
