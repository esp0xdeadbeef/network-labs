{
  layer = "SMS";
  traceId = "FS-760-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-760-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-760-HDS-010-SDS-010-SMS-030-receiver-reverse-initiation-denial.md";
  titleSlug = "receiver-reverse-initiation-denial";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-760-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-760-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
