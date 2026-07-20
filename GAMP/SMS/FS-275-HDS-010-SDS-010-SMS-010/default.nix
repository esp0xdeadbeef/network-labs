{
  layer = "SMS";
  traceId = "FS-275-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-275-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-275-HDS-010-SDS-010-SMS-010-virtual-adapter-transit-relation-preservation.md";
  titleSlug = "virtual-adapter-transit-relation-preservation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-275-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-275-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
