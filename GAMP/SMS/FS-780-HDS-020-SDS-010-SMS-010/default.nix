{
  layer = "SMS";
  traceId = "FS-780-HDS-020-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-780-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-780-HDS-020-SDS-010-SMS-010-equivalence-row-atomization.md";
  titleSlug = "equivalence-row-atomization";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-780-HDS-020-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-780-HDS-020-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
