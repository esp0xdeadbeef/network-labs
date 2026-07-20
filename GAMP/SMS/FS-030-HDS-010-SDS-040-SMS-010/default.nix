{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-040-SMS-010";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-040;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-040-SMS-010-platform-independence-contract.md";
  titleSlug = "platform-independence-contract";
  purpose = "Active row-local mini-SMT input template for compiler platform independence.";
  evidenceBoundary = "row-local-mini-smt";
  sourceInputs = {
    "FS-030-HDS-010-SDS-040-SMS-010" = {
      traceId = "FS-030-HDS-010-SDS-040-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-040-SMS-010/intent.nix";
      maxRuntimeTargets = 5;
    };
  };
  evidence = {
    observedResult = "2026-07-04 compiler construction test and live mini-SMT runtime wrapper passed for platform-independent output, renderer selector rejection, bridge-name rejection, substrate technology selector rejection, and output leak seeded negatives";
    evidenceDirs = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053321Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053649Z"
      "/tmp/active-lab-mini-smt-runs/20260704T053642Z-2913672/FS-030-HDS-010-SDS-040-SMS-010"
    ];
  };
}
