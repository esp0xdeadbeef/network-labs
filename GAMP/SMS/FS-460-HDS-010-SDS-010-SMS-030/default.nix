{
  layer = "SMS";
  traceId = "FS-460-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-460-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-460-HDS-010-SDS-010-SMS-030-nebula-overlay-route-metadata.md";
  titleSlug = "nebula-overlay-route-metadata";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-460-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-460-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
