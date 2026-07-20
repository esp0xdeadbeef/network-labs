{
  layer = "SMS";
  traceId = "FS-725-HDS-020-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-725-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-725-HDS-020-SDS-010-SMS-010-vlan2-management-integration.md";
  titleSlug = "vlan2-management-integration";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-725-HDS-020-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-725-HDS-020-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
