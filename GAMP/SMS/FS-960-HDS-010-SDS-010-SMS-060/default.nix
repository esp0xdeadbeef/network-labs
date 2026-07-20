{
  layer = "SMS";
  traceId = "FS-960-HDS-010-SDS-010-SMS-060";
  parentSds = ../../SDS/FS-960-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-960-HDS-010-SDS-010-SMS-060-validation-prerequisite-startup-gate.md";
  titleSlug = "validation-prerequisite-startup-gate";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-960-HDS-010-SDS-010-SMS-060";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-960-HDS-010-SDS-010-SMS-060/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
