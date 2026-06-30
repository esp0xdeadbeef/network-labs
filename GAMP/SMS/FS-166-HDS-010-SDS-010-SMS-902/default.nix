{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-902";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Renderer-entry NixOS p2p CPM source template.";
  evidenceBoundary = "active-lab mini SMT/SIT";
  sourceInputs.renderer-nixos-p2p = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-902";
    kind = "renderer-input";
    rendererTarget = "nixos";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-p2p-cpm.nix";
    test = "tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh";
    maxRuntimeTargets = 2;
  };
  templateTests = [ "tests/test-active-lab-mini-smt-runtime-nixos-p2p-renderer-input.sh" ];
}
