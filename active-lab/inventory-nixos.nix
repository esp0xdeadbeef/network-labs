{
  activeLabInventoryStub = {
    kind = "mini-smt-renderer-input-stub";
    miniSmtId = "renderer-nixos";
    rendererTarget = "nixos";
    entryBoundary = "renderer-input";
    traceId = "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime";

    cpmInput = ../GAMP/SMT/mini-smt/runtime-nixos-cpm.nix;
    test = ../tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh;
    runner = ../tests/run-active-lab-mini-smt.sh;

    note = "Inventory is provenance for the renderer-nixos SMS-owned mini SMT input. The source fixture carries the on-prem VLAN2 management adapter required by the s-router runtime consumers.";

    runtimeManagement = {
      vlan2 = "management-only";
      testDhcpUplinks = [
        "vlan4"
        "vlan5"
      ];
    };
  };
}
