{
  layer = "SMS";
  traceId = "FS-700-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-700-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-700-HDS-010-SDS-010-SMS-010-lab-source-manifest.md";
  titleSlug = "lab-source-manifest";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-700-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-700-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
