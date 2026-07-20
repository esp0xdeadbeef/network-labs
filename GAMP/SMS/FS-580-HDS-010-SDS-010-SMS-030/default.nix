{
  layer = "SMS";
  traceId = "FS-580-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-580-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-580-HDS-010-SDS-010-SMS-030-generic-egress-dns-bypass-denial.md";
  titleSlug = "generic-egress-dns-bypass-denial";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-580-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-580-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
