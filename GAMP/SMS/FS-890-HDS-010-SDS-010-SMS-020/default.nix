{
  layer = "SMS";
  traceId = "FS-890-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-890-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-890-HDS-010-SDS-010-SMS-020-structured-operational-record-emission.md";
  titleSlug = "structured-operational-record-emission";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-890-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-890-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
