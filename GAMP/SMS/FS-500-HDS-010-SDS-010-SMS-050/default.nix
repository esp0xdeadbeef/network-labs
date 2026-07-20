{
  layer = "SMS";
  traceId = "FS-500-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-500-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-500-HDS-010-SDS-010-SMS-050-runtime-p2p-bridge-colocation.md";
  titleSlug = "runtime-p2p-bridge-colocation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-500-HDS-010-SDS-010-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-050/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
