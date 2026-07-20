{
  layer = "SMS";
  traceId = "FS-380-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-380-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-010-SDS-010-SMS-020-private-ipv4-nat-selection.md";
  titleSlug = "private-ipv4-nat-selection";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-380-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-380-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
