{
  layer = "SMS";
  traceId = "FS-100-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-100-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-100-HDS-010-SDS-010-SMS-020-deterministic-source-identity.md";
  titleSlug = "deterministic-source-identity";
  purpose = "Deterministic source identity construction-only source template.";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-100-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
