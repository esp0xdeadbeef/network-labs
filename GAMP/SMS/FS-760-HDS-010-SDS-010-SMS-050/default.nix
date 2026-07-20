{
  layer = "SMS";
  traceId = "FS-760-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-760-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-760-HDS-010-SDS-010-SMS-050-receiver-multicast-flooding-denial.md";
  titleSlug = "receiver-multicast-flooding-denial";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-760-HDS-010-SDS-010-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-050/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
