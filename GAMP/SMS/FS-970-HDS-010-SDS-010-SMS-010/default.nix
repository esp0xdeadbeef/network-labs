{
  layer = "SMS";
  traceId = "FS-970-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-970-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-010-SMS-010-static-client-reservation-contract.md";
  titleSlug = "static-client-reservation-contract";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-970-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
