let
  source = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix;
  cpm = import source;
in
{
  activeLabInventoryStub = {
    kind = "runtime-clab-inventory-stub";
    miniSmtId = "renderer-clab";
    rendererTarget = "clab";
    entryBoundary = "renderer-input";
    traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-clab";
    inherit source;
    cpmInput = source;
    test = ../tests/test-active-lab-mini-smt-renderer-clab-only.sh;
    runner = ../tests/run-active-lab-mini-smt.sh;
    note = "Inventory is provenance for the renderer-clab SMS-owned mini SMT input. The source fixture carries the on-prem VLAN2 management adapter required by the s-router-clab runtime consumer.";
    runtimeManagement.vlan2 = "management-only";
  };

  deployment = cpm.control_plane_model.deployment;
  deploymentHosts = cpm.deploymentHosts;
}
