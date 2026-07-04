{
  layer = "SIT";
  traceId = "FS-860-HDS-010-SDS-010";
  smsInputs = {
    "FS-860-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-860-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-010-persistent-service-state.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-860-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-860-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-020-required-state-retention.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-860-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-860-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-030-scoped-storage-binding-emission.md";
      role = "scoped-storage-binding-active-lab-runtime-artifact";
      evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
    };
  };
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-860-HDS-010-SDS-010-SMS-030";
    liveCommand = "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-860-HDS-010-SDS-010-SMS-030.sh";
    observedResult = "NOT OK pending current live run: FS-860-HDS-010-SDS-010-SMS-030 now requires selected active-lab runtime artifact proof on s-router-nixos, s-router-clab, and s-router-test-clients; runtime target split is 5/5/0.";
  };
}
