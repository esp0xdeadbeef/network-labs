{
  layer = "SMS";
  traceId = "FS-360-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-360-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-360-HDS-010-SDS-010-SMS-020-public-prefix-return-route-precondition.md";
  titleSlug = "public-prefix-return-route-precondition";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-360-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-360-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
