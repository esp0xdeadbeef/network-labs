{
  layer = "SMT";
  traceId = "FS-090-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "runtime";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-090-HDS-010-SDS-010-SMS-010-no-downstream-heuristic-repair.md";
  titleSlug = "no-downstream-heuristic-repair";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-090-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-090-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-090-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-090-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    expectedRelationIds = [ "FS-090-HDS-010-SDS-010-SMS-010__mini-verify" ];
    maxRuntimeTargets = 5;
    evidenceBoundary = "runtime";
  };
  status = "OK";
  evidence = {
    owningRepo = "network-codex-agent";
    focusedTest = "tests/test-gamp-sms-input-contracts.sh";
    liveScript = "network-codex-agent/scripts/smt-live-FS-090-HDS-010-SDS-010-SMS-010.sh";
    sitLiveScript = "network-codex-agent/scripts/sit-live-FS-090-HDS-010-SDS-010.sh";
    scriptContractTest = "network-codex-agent/tests/test-smt-live-FS-090-HDS-010-SDS-010-SMS-010.sh";
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-090-HDS-010-SDS-010-SMS-010";
    fullLoopCommand = "S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-090-HDS-010-SDS-010-SMS-010 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 NETWORK_REPO_DIRECT_TEST_OK=1 MINI_SMT_OFFLINE_VERIFY=0 bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos";
    networkLabsRev = "4ab9987cccf95c32d31c300e5a52ad16910ac91e";
    nixosLockCommit = "75c0032e6a38";
    networkCodexAgentCommit = "c45f7f51";
    networkCompilerCommit = "aedc0f100737";
    networkForwardingModelCommit = "c351590f7d47";
    cpmCommit = "75719870f9d8";
    rendererNixosCommit = "d471f08b9e4b";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T093243Z-3081461/FS-090-HDS-010-SDS-010-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-090-HDS-010-SDS-010-SMS-010/20260704T092129Z"
      "/tmp/s-router-live-smoke/FS-090-HDS-010-SDS-010-SMS-010/20260704T093244Z"
      "/tmp/s-router-live-smoke/FS-090-HDS-010-SDS-010-SMS-010/20260704T093329Z"
    ];
    pinnedBuild = "nixosConfigurations.s-router-nixos.config.system.build.nixos-shell";
    manualEnumeration = {
      expectedRuntimeTargets = [
        "mini-smt-FS-090-HDS-010-SDS-010-SMS-010-client-edge"
        "mini-smt-FS-090-HDS-010-SDS-010-SMS-010-downstream-selector"
        "mini-smt-FS-090-HDS-010-SDS-010-SMS-010-policy"
        "mini-smt-FS-090-HDS-010-SDS-010-SMS-010-testnet-edge"
        "mini-smt-FS-090-HDS-010-SDS-010-SMS-010-upstream-selector"
      ];
      s-router-nixos = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 5;
        traceHits = 29;
        relationHits = 38;
        downstreamRepairRecords = 0;
        downstreamInventionRecords = 0;
        nameShortcutRecords = 0;
        defaultInferenceRecords = 0;
      };
      s-router-clab = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 5;
        traceHits = 29;
        relationHits = 38;
        downstreamRepairRecords = 0;
        downstreamInventionRecords = 0;
        nameShortcutRecords = 0;
        defaultInferenceRecords = 0;
      };
      s-router-test-clients = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 0;
        traceHits = 1;
        relationHits = 0;
        downstreamRepairRecords = 0;
        downstreamInventionRecords = 0;
        nameShortcutRecords = 0;
        defaultInferenceRecords = 0;
      };
    };
    observedResult = "OK live on 2026-07-04: full-loop active-lab validation passed for locked source /nix/store/bldixbjx05i8fj4nmj3y7nnibp67n3ss-source with full SMS trace FS-090-HDS-010-SDS-010-SMS-010. Construction proved incomplete handoff, missing interface declarations, downstream continuation after failure, name-based shortcuts, and downstream-invented behavior are rejected. Live runtime artifacts on s-router-nixos and s-router-clab each exposed exactly five bounded runtime targets and relationHits=38; s-router-test-clients exposed the trace with zero router runtime targets. Manual enumeration confirmed downstreamRepairRecords=0, downstreamInventionRecords=0, nameShortcutRecords=0, and defaultInferenceRecords=0 on all three hosts. This is SMT/SIT active-lab evidence only, not HAT/SAT or production readiness.";
  };
}
