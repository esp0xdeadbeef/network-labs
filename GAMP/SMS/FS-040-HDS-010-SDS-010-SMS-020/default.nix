{
  layer = "SMS";
  traceId = "FS-040-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-040-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-020-physical-interface-attachment-cardinality.md";
  titleSlug = "physical-interface-attachment-cardinality";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-040-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
