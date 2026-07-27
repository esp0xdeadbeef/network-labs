{
  layer = "SMS";
  traceId = "FS-560-HDS-010-SDS-020-SMS-020";
  parentSds = ../../SDS/FS-560-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-560-HDS-010-SDS-020-SMS-020-source-scoped-resolver-materialization.md";
  titleSlug = "source-scoped-resolver-materialization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-560-HDS-010-SDS-020-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-560-HDS-010-SDS-020-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
