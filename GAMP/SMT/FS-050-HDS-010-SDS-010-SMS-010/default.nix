{
  layer = "SMT";
  traceId = "FS-050-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-control-plane-model";
    cmcModule = "src/cpm/secret-source-contract.nix";
    cpmCommit = "eade1c264d61db68d02aa8ade64b9ddfe975c4fd";
    networkCodexAgentCommit = "5944213f1687f26cc16d2c68746153b0aefd5d50";
    selectedNetworkLabsRev = "052dd0b60994788f3d3aa518c403a9b94f209762";
    nixosLockCommit = "7fb9744b";
    smtRow = "GAMP/SMT/README.md FS-050-HDS-010-SDS-010-SMS-010";
    status = "OK";
    scope = "CPM protected-inventory boundary: unauthorized consumer rejection, plaintext leak prevention, redacted reference emission";
    activeLabRun = "/tmp/active-lab-mini-smt-runs/20260704T065003Z-2975054/FS-050-HDS-010-SDS-010-SMS-010";
    liveEvidence = [
      "/tmp/s-router-live-smoke/FS-050-HDS-010-SDS-010-SMS-010/20260704T065003Z"
      "/tmp/s-router-live-smoke/FS-050-HDS-010-SDS-010-SMS-010/20260704T065006Z"
    ];
    pinnedBuilds = [
      "nixosConfigurations.s-router-nixos.config.system.build.nixos-shell"
      "nixosConfigurations.s-router-clab.config.system.build.nixos-shell"
      "nixosConfigurations.s-router-test-clients.config.system.build.nixos-shell"
    ];
    observedResult = "2026-07-04 construction wrapper PASS, CPM protected-inventory boundary PASS, active-lab runner PASS with offline/pinned runtime verifiers correctly not applicable to construction-only row, manual pinned builds PASS for s-router-nixos/s-router-clab/s-router-test-clients, and context-only host artifacts expose runtimeTargetCount=0 with traceHits=2";
  };
}
