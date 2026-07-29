{
  layer = "SMS";
  traceId = "FS-800-HDS-030-SDS-020-SMS-030";
  parentSds = ../../SDS/FS-800-HDS-030-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-030-delegated-prefix-lease-state-publication.md";
  titleSlug = "delegated-prefix-lease-state-publication";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-800-HDS-030-SDS-020-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
