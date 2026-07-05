{
  layer = "SMT";
  traceId = "FS-060-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "runtime";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-060-HDS-010-SDS-010-SMS-010-runtime-fact-boundary.md";
  titleSlug = "runtime-fact-boundary";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-060-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-060-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-060-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-060-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    expectedRelationIds = [ "FS-060-HDS-010-SDS-010-SMS-010__mini-verify" ];
    maxRuntimeTargets = 5;
    evidenceBoundary = "runtime";
  };
  status = "OK";
  evidence = {
    owningRepo = "network-control-plane-model";
    focusedTest = "tests/test-service-provider-endpoints.sh";
    integrationTest = "network-codex-agent/tests/test-sit-fs060-hds010-sds010-endpoint-runtime-fact-boundary.sh";
    liveScript = "network-codex-agent/scripts/smt-live-FS-060-HDS-010-SDS-010-SMS-010.sh";
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-060-HDS-010-SDS-010-SMS-010";
    fullLoopCommand = "S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-060-HDS-010-SDS-010-SMS-010 RUN_NETWORK_REPO_TESTS=0 RUN_CONTAINERLAB_TESTS=0 LAUNCH_HETZNER_MACHINE=0 REBOOT_S_ROUTER_TEST_CLIENTS=1 RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 NETWORK_REPO_DIRECT_TEST_OK=1 MINI_SMT_OFFLINE_VERIFY=0 bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos";
    networkLabsRev = "a7df2334960b6422f285ff3e7f51afb3e3c8ab98";
    nixosLockCommit = "ebd9add2";
    cpmCommit = "76ae522c1368db2b1e8b87eed13e62bd1b15119b";
    rendererNixosCommit = "0beb26f6f2cc93538509865710d0975b201eadb2";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T072156Z-2998521/FS-060-HDS-010-SDS-010-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-060-HDS-010-SDS-010-SMS-010/20260704T072157Z"
      "/tmp/s-router-live-smoke/FS-060-HDS-010-SDS-010-SMS-010/20260704T072252Z"
    ];
    pinnedBuild = "nixosConfigurations.s-router-nixos.config.system.build.nixos-shell";
    manualEnumeration = {
      expectedRuntimeTargets = [
        "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-client-edge"
        "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-downstream-selector"
        "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-policy"
        "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-core-vlan4-client-dhcp-slaac"
        "mini-smt-FS-060-HDS-010-SDS-010-SMS-010-upstream-selector"
      ];
      s-router-nixos = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 5;
        traceHits = 29;
        providerEndpointRecords = 0;
      };
      s-router-clab = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 5;
        traceHits = 29;
        providerEndpointRecords = 0;
      };
      s-router-test-clients = {
        artifact = "/etc/network-artifacts/control-plane.json";
        runtimeTargetCount = 0;
        traceHits = 1;
        providerEndpointRecords = 0;
      };
    };
    observedResult = "OK live on 2026-07-04: full-loop active-lab validation passed for locked source /nix/store/8m09agpz5bbqdcfyf1gvpayg7v1sl3lx-source with full SMS trace FS-060-HDS-010-SDS-010-SMS-010. CPM construction proved provider endpoints bind only from explicit inventory runtime facts and reject missing endpoint facts. SIT boundary proved the NixOS renderer consumes providerEndpoints from CPM and does not invent endpoint addresses. Live runtime artifacts on s-router-nixos and s-router-clab each exposed exactly five bounded runtime targets; s-router-test-clients exposed the trace with zero router runtime targets. Manual enumeration confirmed providerEndpointRecords=0 on all three hosts. This is SMT/SIT active-lab evidence only, not HAT/SAT or production readiness.";
  };
}
