{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-040-SMS-010";
  evidenceBoundary = "row-local-mini-smt";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-040-SMS-010__mini-verify"
    ];
  };
  evidence = {
    owningRepo = "network-compiler";
    focusedTest = "tests/test-FS-030-HDS-010-SDS-040-SMS-010.sh";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-040-SMS-010";
    status = "OK";
    command = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010";
    maxRuntimeTargets = 5;
    observedResult = "2026-07-04 live mini-SMT passed: compiler construction predicates passed, offline verifier was skipped, s-router-nixos and s-router-clab each emitted and enumerated five full-trace runtime targets, s-router-test-clients emitted zero runtime targets, and pinned s-router-nixos build passed";
    evidenceDirs = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053321Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053649Z"
      "/tmp/active-lab-mini-smt-runs/20260704T053642Z-2913672/FS-030-HDS-010-SDS-040-SMS-010"
    ];
    scope = "Compiler platform independence contract: refuses renderer-specific, deployment-platform-specific, or vendor-specific concepts in compiler output; rejects intent fields selecting specific renderers or technologies";
  };
}
