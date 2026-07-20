{
  layer = "SMS";
  traceId = "FS-860-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-860-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-010-persistent-service-state.md";
  titleSlug = "persistent-service-state";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-860-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
