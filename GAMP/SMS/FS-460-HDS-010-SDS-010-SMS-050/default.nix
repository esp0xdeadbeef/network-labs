{
  layer = "SMS";
  traceId = "FS-460-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-460-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-460-HDS-010-SDS-010-SMS-050-nebula-delegated-public-egress-default.md";
  titleSlug = "nebula-delegated-public-egress-default";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-460-HDS-010-SDS-010-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-050/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
