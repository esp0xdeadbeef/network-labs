{
  layer = "SMS";
  traceId = "FS-230-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-230-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-030-public-ingress-return-authority-separation.md";
  titleSlug = "public-ingress-return-authority-separation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-230-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
