{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-901";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Renderer-entry NixOS single-container CPM source template.";
  evidenceBoundary = "active-lab mini SMT/SIT";
  sourceInputs."FS-166-HDS-010-SDS-010-SMS-901" = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-901";
    kind = "renderer-input";
    rendererTarget = "nixos";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix";
    test = "tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh";
    maxRuntimeTargets = 1;
  };
  templateTests = [ "tests/test-active-lab-mini-smt-runtime-nixos-renderer-input.sh" ];
}
