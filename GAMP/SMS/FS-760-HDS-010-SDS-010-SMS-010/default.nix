{
  layer = "SMS";
  traceId = "FS-760-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-760-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-760-HDS-010-SDS-010-SMS-010-receiver-discovery-access-policy.md";
  titleSlug = "receiver-discovery-access-policy";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-760-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
