{
  activeLabInventoryStub = {
    kind = "mini-smt-renderer-input-stub";
    miniSmtId = "renderer-nixos-p2p";
    rendererTarget = "nixos";
    entryBoundary = "renderer-input";
    traceId = "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime-p2p";

    cpmInput = ../GAMP/SMT/mini-smt/runtime-nixos-p2p-cpm.nix;
    test = ../tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh;
    runner = ../tests/run-active-lab-mini-smt.sh;

    note = "Inventory is provenance for this p2p renderer-input mini SMT (edge-a + edge-b with static routes). Serves FS-500-HDS-010-SDS-010-SMS-020 and FS-500-HDS-010-SDS-010-SMS-030 runtime SIT/HAT evidence per Validation Evidence Boundary split declaration.";

    runtimeManagement = {
      vlan2 = "management-only";
      testDhcpUplinks = [
        "vlan4"
        "vlan5"
      ];
    };
  };
}
