{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-120";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-120-nixos-per-lane-return-path-routing.md";
  miniSmtId = "FS-370-HDS-010-SDS-010-SMS-120";
  titleSlug = "nixos-per-lane-return-path-routing";
  evidenceBoundary = "split";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-120__mini-verify" ];
    inventories = {
      clab = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-120/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-120/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-120/inventory-test-clients.nix";
    };
  };
  status = "OK";
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-120";
    owningRepo = "network-renderer-nixos";
    focusedTest = "tests/FS-370-HDS-010-SDS-010-SMS-120.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-120";
    smtRow = "GAMP/SMT/README.md row 514";
    status = "OK";
    verifiedAt = "network-renderer-nixos local HEAD 295f84d plus working tree (2026-07-02)";
    maxRuntimeTargets = 3;
    scope = "NixOS FS-370 per-lane return-path materialization: renderer emits and validates per-lane destination ip rules, DS reverse nft accept rules, no shared-interface default catch-all, and correct return-route output interface/gateway. Active-lab context currently reports host artifact context and does not promote runtime packet acceptance.";
  };
}
