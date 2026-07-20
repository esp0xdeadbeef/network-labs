{
  layer = "SMS";
  traceId = "FS-850-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-850-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-850-HDS-010-SDS-010-SMS-030-secret-bearing-output-boundary.md";
  titleSlug = "secret-bearing-output-boundary";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-850-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-850-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
