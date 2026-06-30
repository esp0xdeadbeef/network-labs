{
  layer = "SIT";
  traceId = "FS-370-HDS-010-SDS-010";
  smsInputs = {
    "FS-370-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-370-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "unrelated-egress-route-denial";
      evidenceBoundary = "construction-only";
    };
    "FS-370-HDS-010-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-370-HDS-010-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/intent.nix";
      role = "lane-egress-binding";
    };
    "FS-370-HDS-010-SDS-010-SMS-101" = {
      smtRow = ../../SMT/FS-370-HDS-010-SDS-010-SMS-101;
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-101/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-050";
    liveCommand = "NETWORK_REPO_DIRECT_TEST_OK=1 S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs370-active-lab-lane-egress-runtime-check.sh --live";
    sourcePaths = [
      "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/intent.nix"
    ];
    observedResult = "OK on 2026-06-30: NETWORK_REPO_DIRECT_TEST_OK=1 S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs370-active-lab-lane-egress-runtime-check.sh --live passed after selecting SIT FS-370-HDS-010-SDS-010; evidence proves the five-node lane path on s-router-nixos and s-router-clab with runtimeTargets=5 and uplinkLaneHits=1, and proves s-router-test-clients by artifact-derived host bridge/uplink materialization with routerContainers=0, hostBridges=5, and uplink=testnet; row-local SMT/SIT evidence only, not HAT/SAT acceptance";
  };
}
