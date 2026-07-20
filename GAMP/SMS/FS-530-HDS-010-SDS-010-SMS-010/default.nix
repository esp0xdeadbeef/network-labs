{
  layer = "SMS";
  traceId = "FS-530-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-530-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-530-HDS-010-SDS-010-SMS-010-dns-resolver-advertisement.md";
  titleSlug = "dns-resolver-advertisement";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-530-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-530-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
