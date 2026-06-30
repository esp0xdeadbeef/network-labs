{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-904";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Renderer-entry CLAB CPM source template.";
  evidenceBoundary = "active-lab mini SMT/SIT";
  sourceInputs.renderer-clab = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-904";
    kind = "renderer-input";
    rendererTarget = "clab";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix";
    test = "tests/test-active-lab-mini-smt-renderer-clab-only.sh";
    maxRuntimeTargets = 2;
  };
  templateTests = [ "tests/test-active-lab-mini-smt-renderer-clab-only.sh" ];
}
