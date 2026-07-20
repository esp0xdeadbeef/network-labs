{
  layer = "SMS";
  traceId = "FS-255-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-255-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-255-HDS-010-SDS-010-SMS-010-core-role-host-facing-interface-cardinality.md";
  titleSlug = "core-role-host-facing-interface-cardinality";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-255-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-255-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
