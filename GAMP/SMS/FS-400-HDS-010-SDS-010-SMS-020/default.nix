{
  layer = "SMS";
  traceId = "FS-400-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-400-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-400-HDS-010-SDS-010-SMS-020-ula-nat66-selection.md";
  titleSlug = "ula-nat66-selection";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-400-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
