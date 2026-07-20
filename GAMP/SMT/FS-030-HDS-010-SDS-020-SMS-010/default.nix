{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-020-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-020-SMS-010-stage-topology-enforcement.md";
  titleSlug = "stage-topology-enforcement";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-020-SMS-010__mini-verify"
    ];
  };
  status = "OK";
  evidence = {
    maxRuntimeTargets = 5;
    observedResult = "2026-07-04: compiler construction test, row-specific live wrapper, MINI_SMT_OFFLINE_VERIFY=0 mini-SMT runner, pinned s-router-nixos build, and manual runtime-debugger p2p/routes/runtime_signals enumeration all pass for FS-030-HDS-010-SDS-020-SMS-010";
  };
}
