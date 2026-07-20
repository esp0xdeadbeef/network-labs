{
  layer = "SMS";
  traceId = "FS-800-HDS-010-SDS-030-SMS-030";
  parentSds = ../../SDS/FS-800-HDS-010-SDS-030;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-030-SMS-030-hat-source-lock-selection.md";
  titleSlug = "hat-source-lock-selection";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-800-HDS-010-SDS-030-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-030-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
