{
  layer = "SDS";
  traceId = "FS-030-HDS-010-SDS-050";
  purpose = "Core role boundary source grouping.";
  status = "OK";
  smsInputs = {
    "FS-030-HDS-010-SDS-050-SMS-010" = {
      smsRow = ../../SMS/FS-030-HDS-010-SDS-050-SMS-010;
      miniSmtIds = [
        "FS-030-HDS-010-SDS-050-SMS-010"
        "canonical-source-stub"
      ];
      inputKinds = [
        "intent-source"
        "source-reference"
      ];
      evidenceBoundary = "construction-plus-live-artifact";
    };
  };
  evidence = {
    observedResult = "2026-07-04 active-lab direct verifier and active-lab runner PASS; NixOS and CLAB have the five expected runtime targets, test-clients has zero runtime targets, and runtime-debugger p2p/routes/runtime_signals passed with only the known CLAB intent/debug-bundle artifact warnings";
    commands = [
      "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-030-HDS-010-SDS-050-SMS-010.sh"
      "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh"
      "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh"
      "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-050-SMS-010"
      "python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals"
    ];
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T055916Z-2927018/FS-030-HDS-010-SDS-050-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055541Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055923Z"
    ];
  };
  templateTests = [
    "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh"
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
