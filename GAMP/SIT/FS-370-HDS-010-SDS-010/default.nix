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
      "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-040/intent.nix"
      "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/intent.nix"
      "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-101/intent.nix"
    ];
    observedResult = "NOT OK on 2026-07-02: row-local source and small CPM proof now pass after removing the duplicate testnet bridgeNetwork from the FS-370 mini-SMT inventories. PASS: tests/test-active-lab-mini-smt-lane-egress-binding-only.sh, NETWORK_REPO_DIRECT_TEST_OK=1 tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-050, and NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_CPM_PATH=/home/deadbeef/github/network-control-plane-model ../network-codex-agent/scripts/fs370-active-lab-lane-egress-runtime-check.sh --small. Live closure is pending: s-router-nixos 192.168.1.17 unreachable, s-router-clab artifact runtimeTargets=0, and s-router-test-clients missing the FS-370 host bridge/uplink materialization. The failure is preserved in network-codex-agent tests/observed-runtime-failures/test-20260702T181948Z-fs370-active-lab-live-stale-unreachable.sh with full log tests/observed-runtime-failures/logs/test-20260702T181948Z-fs370-active-lab-live-stale-unreachable.log. This remains row-local SMT/SIT evidence only, not HAT/SAT acceptance.";
  };
}
