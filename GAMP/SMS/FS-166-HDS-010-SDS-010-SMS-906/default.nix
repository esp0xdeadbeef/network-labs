{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-906";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Renderer-entry Nebula CPM source template.";
  evidenceBoundary = "active-lab mini SMT/SIT";
  sourceInputs.renderer-nebula = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-906";
    kind = "renderer-input";
    rendererTarget = "nebula";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-nebula-cpm.nix";
    test = "tests/test-active-lab-mini-smt-renderer-nebula-only.sh";
    maxRuntimeTargets = 2;
  };
  templateTests = [ "tests/test-active-lab-mini-smt-renderer-nebula-only.sh" ];
}
