{
  layer = "SMS";
  traceId = "FS-166-HDS-010-SDS-010-SMS-905";
  parentSds = ../../SDS/FS-166-HDS-010-SDS-010;
  purpose = "Renderer-entry WireGuard CPM source template.";
  evidenceBoundary = "active-lab mini SMT/SIT";
  sourceInputs.renderer-wireguard = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-905";
    kind = "renderer-input";
    rendererTarget = "wireguard";
    sourcePath = "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/wireguard-provider-contract.nix";
    test = "tests/test-active-lab-mini-smt-renderer-wireguard-only.sh";
    maxRuntimeTargets = 1;
  };
  templateTests = [ "tests/test-active-lab-mini-smt-renderer-wireguard-only.sh" ];
}
