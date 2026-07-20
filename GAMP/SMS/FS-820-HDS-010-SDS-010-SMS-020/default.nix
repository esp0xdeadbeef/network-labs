{
  layer = "SMS";
  traceId = "FS-820-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-820-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-020-secret-source-class-portability.md";
  titleSlug = "secret-source-class-portability";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-820-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
