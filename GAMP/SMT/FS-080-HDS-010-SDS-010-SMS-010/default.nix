{
  layer = "SMT";
  traceId = "FS-080-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "runtime";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-080-HDS-010-SDS-010-SMS-010-missing-ambiguous-fact-failure.md";
  titleSlug = "missing-ambiguous-fact-failure";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-080-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-080-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-080-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-080-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    expectedRelationIds = [ "FS-080-HDS-010-SDS-010-SMS-010__mini-verify" ];
    maxRuntimeTargets = 5;
    evidenceBoundary = "runtime";
  };
  status = "OK";
  evidence = {
    owningRepo = "network-codex-agent";
    focusedTest = "tests/test-gamp-sms-input-contracts.sh";
    liveScript = "network-codex-agent/scripts/smt-live-FS-080-HDS-010-SDS-010-SMS-010.sh";
    sitLiveScript = "network-codex-agent/scripts/sit-live-FS-080-HDS-010-SDS-010.sh";
    scriptContractTest = "network-codex-agent/tests/test-smt-live-FS-080-HDS-010-SDS-010-SMS-010.sh";
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-080-HDS-010-SDS-010-SMS-010";
    fullLoopCommand = "S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-080-HDS-010-SDS-010-SMS-010 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 NETWORK_REPO_DIRECT_TEST_OK=1 MINI_SMT_OFFLINE_VERIFY=0 bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos";
    networkLabsRev = "b96900ea11e473cb4230281573887aaefa09462e";
    nixosLockCommit = "9e9619fd";
    networkCodexAgentCommit = "b27f5394";
    cpmCommit = "2c0bd4d0784f009ccbf2b8533d6a9db6e9659b4f";
    rendererNixosCommit = "d1f0c386f9e7e61421db572e89e63b6dd89833de";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T084105Z-3054910/FS-080-HDS-010-SDS-010-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-080-HDS-010-SDS-010-SMS-010/20260704T084107Z"
      "/tmp/s-router-live-smoke/FS-080-HDS-010-SDS-010-SMS-010/20260704T084201Z"
    ];
    pinnedBuild = "nixosConfigurations.s-router-nixos.config.system.build.nixos-shell";
    manualEnumeration = {
      expectedRuntimeTargets = [
        "mini-smt-FS-080-HDS-010-SDS-010-SMS-010-client-edge"
        "mini-smt-FS-080-HDS-010-SDS-010-SMS-010-downstream-selector"
        "mini-smt-FS-080-HDS-010-SDS-010-SMS-010-policy"
        "mini-smt-FS-080-HDS-010-SDS-010-SMS-010-core-vlan4-client-dhcp-slaac"
        "mini-smt-FS-080-HDS-010-SDS-010-SMS-010-upstream-selector"
      ];
      s-router-nixos = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 5;
        traceHits = 29;
        relationHits = 38;
        requiredFactViolationRecords = 0;
        downstreamRepairRecords = 0;
        unknownSourceClassRecords = 0;
      };
      s-router-clab = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 5;
        traceHits = 29;
        relationHits = 38;
        requiredFactViolationRecords = 0;
        downstreamRepairRecords = 0;
        unknownSourceClassRecords = 0;
      };
      s-router-test-clients = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 0;
        traceHits = 1;
        relationHits = 0;
        requiredFactViolationRecords = 0;
        downstreamRepairRecords = 0;
        unknownSourceClassRecords = 0;
      };
    };
    observedResult = "OK live on 2026-07-04: full-loop active-lab validation passed for locked source /nix/store/1ncva3xfxmr7bv4yb8i136zb541y9j17-source with full SMS trace FS-080-HDS-010-SDS-010-SMS-010. Construction proved required-fact validation accepts present classified facts and rejects missing facts, ambiguous facts, unknown source class, downstream continuation after failure, and defaulted/inferred values. Live runtime artifacts on s-router-nixos and s-router-clab each exposed exactly five bounded runtime targets and relationHits=38; s-router-test-clients exposed the trace with zero router runtime targets. Manual enumeration confirmed requiredFactViolationRecords=0, downstreamRepairRecords=0, and unknownSourceClassRecords=0 on all three hosts. This is SMT/SIT active-lab evidence only, not HAT/SAT or production readiness.";
  };
}
