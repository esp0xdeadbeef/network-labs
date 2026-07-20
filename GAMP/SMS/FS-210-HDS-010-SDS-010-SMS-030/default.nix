{
  layer = "SMS";
  traceId = "FS-210-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-210-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-210-HDS-010-SDS-010-SMS-030-public-ingress-authority-separation.md";
  titleSlug = "public-ingress-authority-separation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-210-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-210-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
