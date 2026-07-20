{
  layer = "SMS";
  traceId = "FS-120-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-120-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-120-HDS-010-SDS-010-SMS-010-deterministic-diagnostics.md";
  titleSlug = "deterministic-diagnostics";
  purpose = "Deterministic Diagnostics (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-120-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-120-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
