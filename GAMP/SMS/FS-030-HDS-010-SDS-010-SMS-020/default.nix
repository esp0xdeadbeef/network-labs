{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-020-realization-binder-authority.md";
  titleSlug = "realization-binder-authority";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-030-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
