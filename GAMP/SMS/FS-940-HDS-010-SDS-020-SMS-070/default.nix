{
  layer = "SMS";
  traceId = "FS-940-HDS-010-SDS-020-SMS-070";
  parentSds = ../../SDS/FS-940-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-940-HDS-010-SDS-020-SMS-070-one-pass-route-materializer.md";
  titleSlug = "one-pass-route-materializer";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-940-HDS-010-SDS-020-SMS-070";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-070/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
