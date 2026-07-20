{
  layer = "SMS";
  traceId = "FS-750-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-750-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-750-HDS-010-SDS-010-SMS-020-receiver-payload-ports.md";
  titleSlug = "receiver-payload-ports";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-750-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-750-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
