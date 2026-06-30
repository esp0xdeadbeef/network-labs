{
  activeLabInventoryStub = {
    kind = "mini-smt-renderer-input-stub";
    miniSmtId = "FS-166-HDS-010-SDS-010-SMS-901";
    miniSmtManifestKey = "FS-166-HDS-010-SDS-010-SMS-901";
    rendererTarget = "nixos";
    entryBoundary = "renderer-input";
    traceId = "FS-166-HDS-010-SDS-010-SMS-901";

    cpmInput = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix;
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
