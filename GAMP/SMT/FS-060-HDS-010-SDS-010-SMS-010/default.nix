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
