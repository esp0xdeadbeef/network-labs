{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-020-SMS-010-stage-topology-enforcement.md";
  titleSlug = "stage-topology-enforcement";
  purpose = "Active row-local mini-SMT input template for compiler stage-topology enforcement.";
  evidenceBoundary = "row-local-mini-smt";
  sourceInputs = {
    "FS-030-HDS-010-SDS-020-SMS-010" = {
      traceId = "FS-030-HDS-010-SDS-020-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-020-SMS-010/intent.nix";
      maxRuntimeTargets = 5;
    };
  };
}
