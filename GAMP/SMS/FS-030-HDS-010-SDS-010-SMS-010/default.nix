{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-010-intent-authority-boundary.md";
  titleSlug = "intent-authority-boundary";
  purpose = "Row-local mini-SMT source for intent authority boundary.";
  evidenceBoundary = "row-local-mini-smt";
  sourceInputs = {
    "FS-030-HDS-010-SDS-010-SMS-010" = {
      traceId = "FS-030-HDS-010-SDS-010-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 5;
    };
  };
}
