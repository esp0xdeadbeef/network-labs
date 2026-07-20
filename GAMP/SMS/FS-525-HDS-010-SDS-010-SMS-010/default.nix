{
  layer = "SMS";
  traceId = "FS-525-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-525-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-525-HDS-010-SDS-010-SMS-010-named-core-resolver-binding.md";
  titleSlug = "named-core-resolver-binding";
  purpose = "Canonical named-core DNS warning-contract source mirror.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-525-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
