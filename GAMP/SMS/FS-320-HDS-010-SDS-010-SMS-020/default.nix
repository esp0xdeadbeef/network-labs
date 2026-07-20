{
  layer = "SMS";
  traceId = "FS-320-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-320-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-010-SDS-010-SMS-020-bridge-link-realization.md";
  titleSlug = "bridge-link-realization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-320-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-320-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
