{
  layer = "SMS";
  traceId = "FS-540-HDS-010-SDS-010-SMS-025";
  parentSds = ../../SDS/FS-540-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-025-uplink-dns-follow-source.md";
  titleSlug = "uplink-dns-follow-source";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-540-HDS-010-SDS-010-SMS-025";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-025/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
