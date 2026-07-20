{
  layer = "SMS";
  traceId = "FS-440-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-440-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-440-HDS-010-SDS-010-SMS-050-provider-runtime-fact-separation.md";
  titleSlug = "provider-runtime-fact-separation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-440-HDS-010-SDS-010-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-440-HDS-010-SDS-010-SMS-050/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
