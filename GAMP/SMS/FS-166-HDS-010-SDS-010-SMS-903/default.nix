{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-903";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Renderer-entry NixOS clients CPM source template.";
  evidenceBoundary = "active-lab mini SMT/SIT";
  sourceInputs."FS-166-HDS-010-SDS-010-SMS-903" = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-903";
    kind = "renderer-input";
    rendererTarget = "nixos-clients";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-access-endpoint-cpm.nix";
    test = "tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh";
    maxRuntimeTargets = 1;
  };
  templateTests = [ "tests/test-active-lab-mini-smt-renderer-nixos-clients-only.sh" ];
}
