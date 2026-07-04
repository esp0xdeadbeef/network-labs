{
  layer = "SDS";
  traceId = "FS-040-HDS-010-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  status = "OK";
  smsInputs = {
    "FS-040-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-040-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "FS-040-HDS-010-SDS-010-SMS-010" ];
      inputKinds = [
        "intent-source"
        "nixos-inventory"
        "clab-inventory"
        "test-client-inventory"
      ];
      evidenceBoundary = "construction-plus-live-active-lab-artifact";
    };
  };
  templateTests = [
    "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/test.sh"
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
  evidence = {
    observedResult = "2026-07-04 PASS: CPM construction wrapper, row-local source test, direct live verifier, active-lab runner, pinned builds, and runtime-debugger p2p/routes/runtime_signals for the focused row";
    commands = [
      "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.sh"
      "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/test.sh"
      "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh"
      "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-040-HDS-010-SDS-010-SMS-010"
      "python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals"
    ];
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T062015Z-2938737/FS-040-HDS-010-SDS-010-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T061645Z"
      "/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T062022Z"
    ];
  };
}
