{
  layer = "SMS";
  traceId = "FS-870-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-870-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-870-HDS-010-SDS-010-SMS-020-ephemeral-state-authority.md";
  titleSlug = "ephemeral-state-authority";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-870-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-870-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
