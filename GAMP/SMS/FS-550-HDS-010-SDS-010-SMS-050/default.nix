{
  layer = "SMS";
  traceId = "FS-550-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-550-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-550-HDS-010-SDS-010-SMS-050-cross-tenant-dns-egress-denial.md";
  titleSlug = "cross-tenant-dns-egress-denial";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-550-HDS-010-SDS-010-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-550-HDS-010-SDS-010-SMS-050/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
