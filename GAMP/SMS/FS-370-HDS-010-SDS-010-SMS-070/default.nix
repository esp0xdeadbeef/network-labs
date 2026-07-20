{
  layer = "SMS";
  traceId = "FS-370-HDS-010-SDS-010-SMS-070";
  parentSds = ../../SDS/FS-370-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-070-core-forwarding-chain.md";
  titleSlug = "core-forwarding-chain";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-370-HDS-010-SDS-010-SMS-070";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-070/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
