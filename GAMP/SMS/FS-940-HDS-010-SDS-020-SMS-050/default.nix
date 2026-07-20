{
  layer = "SMS";
  traceId = "FS-940-HDS-010-SDS-020-SMS-050";
  parentSds = ../../SDS/FS-940-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-940-HDS-010-SDS-020-SMS-050-forwarding-equivalence-group-planner.md";
  titleSlug = "forwarding-equivalence-group-planner";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-940-HDS-010-SDS-020-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-050/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
