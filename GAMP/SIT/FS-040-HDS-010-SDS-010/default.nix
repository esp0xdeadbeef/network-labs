{
  layer = "SIT";
  traceId = "FS-040-HDS-010-SDS-010";
  smsInputs = {
    "FS-040-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-040-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md";
      role = "active-lab-smt-input";
      evidenceBoundary = "construction-plus-live-active-lab-artifact";
    };
  };
  evidence = {
    runtimeComparer = "python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals";
    observedResult = "2026-07-04 direct live verifier and active-lab runner PASS; NixOS/CLAB artifacts carry five public-inventory-audited runtime targets, test-clients carries zero router runtime targets, and manual runtime enumeration plus runtime-debugger p2p/routes/runtime_signals passed";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T062015Z-2938737/FS-040-HDS-010-SDS-010-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T061645Z"
      "/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T062022Z"
    ];
  };
}
