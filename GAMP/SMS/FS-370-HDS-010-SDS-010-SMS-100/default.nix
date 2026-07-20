{
  layer = "SMS";
  traceId = "FS-370-HDS-010-SDS-010-SMS-100";
  parentSds = ../../SDS/FS-370-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-100-upstream-selector-shared-iface-ip-rule-priority.md";
  titleSlug = "upstream-selector-shared-iface-ip-rule-priority";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-370-HDS-010-SDS-010-SMS-100";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-100/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
