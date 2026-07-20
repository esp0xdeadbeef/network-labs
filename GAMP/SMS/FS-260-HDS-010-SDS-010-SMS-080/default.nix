{
  layer = "SMS";
  traceId = "FS-260-HDS-010-SDS-010-SMS-080";
  parentSds = ../../SDS/FS-260-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-260-HDS-010-SDS-010-SMS-080-nfm-forwarding-derivation-contract.md";
  titleSlug = "nfm-forwarding-derivation-contract";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-260-HDS-010-SDS-010-SMS-080";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-080/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
