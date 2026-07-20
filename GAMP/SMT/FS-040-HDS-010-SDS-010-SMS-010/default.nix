{
  layer = "SMT";
  traceId = "FS-040-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md";
  titleSlug = "public-inventory-boundary";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-plus-live-active-lab-artifact";
  };
  status = "OK";
  evidence = {
    runtimeComparer = "python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals";
    selectedNetworkLabsRev = "6114bae73b6431ed7953a5f61857fa6ba93fade4";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T062015Z-2938737/FS-040-HDS-010-SDS-010-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T061645Z"
      "/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T062022Z"
    ];
    observedResult = "2026-07-04 direct live verifier and active-lab runner PASS; construction PASS; NixOS and CLAB artifacts expose five public-inventory-audited runtime targets, test-clients exposes zero router runtime targets, manual runtime enumeration captures interfaces/routes, and runtime-debugger p2p/routes/runtime_signals passes for the focused row";
  };
}
