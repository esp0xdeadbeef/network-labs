{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-050-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md";
  evidenceBoundary = "construction-plus-live-artifact";
  titleSlug = "core-role-boundary";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/intent.nix";
    expectedRelationIds = [ "FS-030-HDS-010-SDS-050-SMS-010__mini-verify" ];
    inventories = {
      clab = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/inventory-test-clients.nix";
    };
  };
  status = "OK";
  evidence = {
    command = "bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh";
    focusedTest = "network-compiler/tests/test-FS-030-HDS-010-SDS-050-SMS-010.sh";
    runtimeComparer = "python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals";
    observedResult = "2026-07-04 direct live verifier and active-lab runner PASS; construction PASS; NixOS and CLAB artifacts expose five expected runtime targets; test-clients exposes zero runtime targets; runtime-debugger p2p/routes/runtime_signals passes for the focused row";
    selectedNetworkLabsRev = "58836c92e9d96d16e0ee073b7771a855afff0014";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T055916Z-2927018/FS-030-HDS-010-SDS-050-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055541Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055923Z"
    ];
  };
}
