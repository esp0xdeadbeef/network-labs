{
  layer = "SMS";
  traceId = "FS-750-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-750-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-750-HDS-010-SDS-010-SMS-030-receiver-fixture-non-authority.md";
  titleSlug = "receiver-fixture-non-authority";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-750-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-750-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
