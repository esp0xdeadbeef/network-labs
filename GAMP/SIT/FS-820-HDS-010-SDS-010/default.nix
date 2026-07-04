{
  layer = "SIT";
  traceId = "FS-820-HDS-010-SDS-010";
  smsInputs = {
    "FS-820-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-010-secret-source-selection.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-020-secret-source-class-portability.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-030-secret-source-policy-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-050-network-labs-sops-configuration-validation.md";
      role = "network-labs-sops-active-lab-runtime-artifact";
      evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
    };
    "FS-820-HDS-010-SDS-010-SMS-060" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-060;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-060/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-060-sops-target-recipient-validation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-820-HDS-010-SDS-010-SMS-050";
    liveCommand = "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-820-HDS-010-SDS-010-SMS-050.sh";
    observedResult = "NOT OK pending current live run: FS-820-HDS-010-SDS-010-SMS-050 now requires selected active-lab runtime artifact proof on s-router-nixos, s-router-clab, and s-router-test-clients; runtime target split is 5/5/0.";
  };
}
