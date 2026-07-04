{
  layer = "SIT";
  traceId = "FS-030-HDS-010-SDS-010";
  smsInputs = {
    "FS-030-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-040/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-040-cpm-binder-source-audit.md";
      role = "row-local-mini-smt";
      evidenceBoundary = "row-local-mini-smt";
    };
    "FS-030-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-010-intent-authority-boundary.md";
      role = "intent-authority-active-lab-runtime";
      evidenceBoundary = "active-lab-mini-smt-runtime";
    };
    "FS-030-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-020-realization-binder-authority.md";
      role = "realization-binder-active-lab-runtime";
      evidenceBoundary = "active-lab-mini-smt-runtime";
    };
    "FS-030-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-030-compiler-behavior-source-audit.md";
      role = "row-local-mini-smt";
      evidenceBoundary = "row-local-mini-smt";
    };
  };
  evidence = {
    command = "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-020.sh";
    constructionCommand = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-020";
    childCommands = {
      "FS-030-HDS-010-SDS-010-SMS-010" = {
        live = "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-010.sh";
        miniSmt = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-010";
      };
      "FS-030-HDS-010-SDS-010-SMS-020" = {
        live = "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-020.sh";
        miniSmt = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-020";
      };
    };
    observedResult = "2026-07-04: children FS-030-HDS-010-SDS-010-SMS-010 and FS-030-HDS-010-SDS-010-SMS-020 active-lab runtime artifacts carried their full trace IDs on s-router-nixos, s-router-clab, and s-router-test-clients. For each validated child, router hosts exposed five bounded runtime targets each; test-clients exposed the trace with zero router runtime targets. Sibling SMS-030 and SMS-040 remain independently tracked by their own child evidence.";
  };
}
