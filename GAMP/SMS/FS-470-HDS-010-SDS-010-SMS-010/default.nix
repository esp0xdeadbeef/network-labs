{
  layer = "SMS";
  traceId = "FS-470-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-470-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-010-wireguard-remote-egress.md";
  titleSlug = "wireguard-remote-egress";
  purpose = "WireGuard remote-egress renderer construction contract.";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "FS-470-HDS-010-SDS-010-SMS-010" = {
      traceId = "FS-470-HDS-010-SDS-010-SMS-010";
      kind = "construction-only";
      rendererTarget = "wireguard";
      maxRuntimeTargets = 0;
    };
  };
}
