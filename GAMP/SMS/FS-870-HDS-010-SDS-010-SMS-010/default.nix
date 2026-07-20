{
  layer = "SMS";
  traceId = "FS-870-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-870-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-870-HDS-010-SDS-010-SMS-010-ephemeral-state-selection.md";
  titleSlug = "ephemeral-state-selection";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-870-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-870-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
