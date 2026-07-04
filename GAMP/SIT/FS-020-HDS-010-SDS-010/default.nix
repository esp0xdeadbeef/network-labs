{
  layer = "SIT";
  traceId = "FS-020-HDS-010-SDS-010";
  smsInputs = {
    "FS-020-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-020-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-020-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-020-HDS-010-SDS-010-SMS-010-source-class-assignment.md";
      role = "source-class-assignment-active-lab-runtime";
      evidenceBoundary = "active-lab-mini-smt-runtime";
    };
  };
  evidence = {
    command = "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-020-HDS-010-SDS-010-SMS-010.sh";
    constructionCommand = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-020-HDS-010-SDS-010-SMS-010";
    observedResult = "2026-07-04: integrated active-lab runtime artifacts carried full trace FS-020-HDS-010-SDS-010-SMS-010 on s-router-nixos, s-router-clab, and s-router-test-clients. Router hosts exposed five bounded runtime targets each; test-clients exposed the trace with zero router runtime targets.";
  };
}
