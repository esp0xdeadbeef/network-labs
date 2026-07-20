{
  layer = "SMS";
  traceId = "FS-982-HDS-010-SDS-010-SMS-070";
  parentSds = ../../SDS/FS-982-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-982-HDS-010-SDS-010-SMS-070-no-oneshot-secret-services.md";
  titleSlug = "no-oneshot-secret-services";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-982-HDS-010-SDS-010-SMS-070";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-070/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
