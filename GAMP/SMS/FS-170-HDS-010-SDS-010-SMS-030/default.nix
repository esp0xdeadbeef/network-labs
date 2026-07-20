{
  layer = "SMS";
  traceId = "FS-170-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-170-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-170-HDS-010-SDS-010-SMS-030-policy-record-normalization.md";
  titleSlug = "policy-record-normalization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-170-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-170-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
