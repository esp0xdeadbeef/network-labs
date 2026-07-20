{
  layer = "SMS";
  traceId = "FS-360-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-360-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-360-HDS-010-SDS-010-SMS-010-downstream-client-public-prefix-authority.md";
  titleSlug = "downstream-client-public-prefix-authority";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-360-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-360-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
