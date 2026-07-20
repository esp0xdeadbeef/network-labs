{
  layer = "SMS";
  traceId = "FS-820-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-820-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-010-secret-source-selection.md";
  titleSlug = "secret-source-selection";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-820-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
