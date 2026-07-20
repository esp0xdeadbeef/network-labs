{
  layer = "SMS";
  traceId = "FS-305-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-305-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-305-HDS-010-SDS-010-SMS-010-virtual-adapter-hygiene-boundary.md";
  titleSlug = "virtual-adapter-hygiene-boundary";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-305-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-305-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
