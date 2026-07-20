{
  layer = "SMS";
  traceId = "FS-350-HDS-010-SDS-010-SMS-060";
  parentSds = ../../SDS/FS-350-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-350-HDS-010-SDS-010-SMS-060-s-router-prod-runtime-delegated-prefix-materialization.md";
  titleSlug = "s-router-prod-runtime-delegated-prefix-materialization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-350-HDS-010-SDS-010-SMS-060";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-350-HDS-010-SDS-010-SMS-060/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
