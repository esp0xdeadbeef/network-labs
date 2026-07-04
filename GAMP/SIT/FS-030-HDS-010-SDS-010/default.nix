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
      role = "row-local-mini-smt";
      evidenceBoundary = "row-local-mini-smt";
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
    command = "NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-010.sh";
    constructionCommand = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-010";
    observedResult = "2026-07-04: child FS-030-HDS-010-SDS-010-SMS-010 active-lab runtime artifacts carried the full trace on s-router-nixos, s-router-clab, and s-router-test-clients. Router hosts exposed five bounded runtime targets each; test-clients exposed the trace with zero router runtime targets. Sibling SMS-020, SMS-030, and SMS-040 remain independently tracked by their own child evidence.";
  };
}
