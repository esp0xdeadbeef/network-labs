{
  layer = "SMS";
  traceId = "FS-390-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-390-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-030-broad-wan-public-ipv4-denial.md";
  titleSlug = "broad-wan-public-ipv4-denial";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-390-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
