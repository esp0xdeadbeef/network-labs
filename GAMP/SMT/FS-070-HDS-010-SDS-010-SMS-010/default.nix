{
  layer = "SMT";
  traceId = "FS-070-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "runtime";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-070-HDS-010-SDS-010-SMS-010-validation-context-boundary.md";
  titleSlug = "validation-context-boundary";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-070-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-070-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-070-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-070-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    expectedRelationIds = [ "FS-070-HDS-010-SDS-010-SMS-010__mini-verify" ];
    maxRuntimeTargets = 5;
    evidenceBoundary = "runtime";
  };
  status = "OK";
  evidence = {
    owningRepo = "network-codex-agent";
    focusedTest = "tests/test-gamp-sms-input-contracts.sh";
    liveScript = "network-codex-agent/scripts/smt-live-FS-070-HDS-010-SDS-010-SMS-010.sh";
    sitLiveScript = "network-codex-agent/scripts/sit-live-FS-070-HDS-010-SDS-010.sh";
    scriptContractTest = "network-codex-agent/tests/test-smt-live-FS-070-HDS-010-SDS-010-SMS-010.sh";
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-070-HDS-010-SDS-010-SMS-010";
    fullLoopCommand = "S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-070-HDS-010-SDS-010-SMS-010 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 NETWORK_REPO_DIRECT_TEST_OK=1 MINI_SMT_OFFLINE_VERIFY=0 bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos";
    networkLabsRev = "8ef4117d91bad97c33ac02f61f00d6bbd6f79583";
    nixosLockCommit = "eba94e93";
    networkCodexAgentCommit = "c4c62045";
    cpmCommit = "ba037068bddba410aab45051248db29baffd00e6";
    rendererNixosCommit = "17b3fdfa5f85f7969062047c2567c1a2f7deb23a";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T080616Z-3029439/FS-070-HDS-010-SDS-010-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-070-HDS-010-SDS-010-SMS-010/20260704T080618Z"
      "/tmp/s-router-live-smoke/FS-070-HDS-010-SDS-010-SMS-010/20260704T080720Z"
    ];
    pinnedBuild = "nixosConfigurations.s-router-nixos.config.system.build.nixos-shell";
    manualEnumeration = {
      expectedRuntimeTargets = [
        "mini-smt-FS-070-HDS-010-SDS-010-SMS-010-client-edge"
        "mini-smt-FS-070-HDS-010-SDS-010-SMS-010-downstream-selector"
        "mini-smt-FS-070-HDS-010-SDS-010-SMS-010-policy"
        "mini-smt-FS-070-HDS-010-SDS-010-SMS-010-core-vlan4-client-dhcp-slaac"
        "mini-smt-FS-070-HDS-010-SDS-010-SMS-010-upstream-selector"
      ];
      s-router-nixos = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 5;
        traceHits = 29;
        relationHits = 38;
        validationContextMutationRecords = 0;
      };
      s-router-clab = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 5;
        traceHits = 29;
        relationHits = 38;
        validationContextMutationRecords = 0;
      };
      s-router-test-clients = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 0;
        traceHits = 1;
        relationHits = 0;
        validationContextMutationRecords = 0;
      };
    };
    observedResult = "OK live on 2026-07-04: full-loop active-lab validation passed for locked source /nix/store/3mxrnfjhys741zavf161hs64wyd5nbza-source with full SMS trace FS-070-HDS-010-SDS-010-SMS-010. Construction proved validation context requires harness, substrate, evidence plan, unchanged model use, and unchanged renderer-contract use, and rejects route/topology/policy/DNS/firewall/overlay mutations. Live runtime artifacts on s-router-nixos and s-router-clab each exposed exactly five bounded runtime targets and relationHits=38; s-router-test-clients exposed the trace with zero router runtime targets. Manual enumeration confirmed validationContextMutationRecords=0 on all three hosts. This is SMT/SIT active-lab evidence only, not HAT/SAT or production readiness.";
  };
}
