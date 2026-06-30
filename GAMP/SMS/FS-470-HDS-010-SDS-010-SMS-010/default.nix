{
  layer = "SMS";
  traceId = "FS-470-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-470-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-010-wireguard-remote-egress.md";
  titleSlug = "wireguard-remote-egress";
  purpose = "WireGuard remote-egress renderer-input active-lab source template.";
  evidenceBoundary = "active-lab mini SMT/SIT";
  sourceInputs = {
    "wireguard-remote-egress" = {
      traceId = "FS-470-HDS-010-SDS-010-SMS-010";
      kind = "renderer-input";
      rendererTarget = "wireguard";
      sourcePath = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/renderer-input/wireguard-remote-egress-cpm.nix";
      test = "tests/test-active-lab-mini-smt-wireguard-remote-egress-only.sh";
      maxRuntimeTargets = 1;
    };
  };
  templateTests = [
    "tests/test-active-lab-mini-smt-wireguard-remote-egress-only.sh"
  ];
}
