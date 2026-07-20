{
  layer = "SMS";
  traceId = "FS-910-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-910-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-910-HDS-010-SDS-010-SMS-040-s-router-prod-public-address-operational-log-redaction.md";
  titleSlug = "s-router-prod-public-address-operational-log-redaction";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-910-HDS-010-SDS-010-SMS-040";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-910-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
