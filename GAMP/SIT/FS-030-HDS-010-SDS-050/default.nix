{
  layer = "SIT";
  traceId = "FS-030-HDS-010-SDS-050";
  smsInputs = {
    "FS-030-HDS-010-SDS-050-SMS-010" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-050-SMS-010;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md";
      role = "intent-source-mini-smt";
      evidenceBoundary = "construction-plus-live-artifact";
    };
  };
  evidence = {
    command = "bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh";
    observedResult = "2026-07-04 direct live verifier and active-lab runner PASS for child SMS; NixOS/CLAB artifacts carry the five expected runtime targets, test-clients carries zero, and runtime-debugger p2p/routes/runtime_signals passes for the focused row";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T055916Z-2927018/FS-030-HDS-010-SDS-050-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055541Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055923Z"
    ];
  };
}
