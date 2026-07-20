{
  layer = "SMT";
  traceId = "FS-162-HDS-010-SDS-040-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md";
  titleSlug = "s-router-prod-comparable-projection";
  source = {
    kind = "validated-canonical-bundle";
    semanticSourceTraceId = "FS-230-HDS-010-SDS-010-SMS-040";
    firstActiveBoundary = "network-compiler";
    rendererTargets = [
      "nixos"
      "clab"
      "openconfig"
    ];
    evidenceBoundary = "construction-only";
  };
  status = "OK";
  evidence = {
    observedResult = "One validated FS-230 canonical bundle identity produced the same normalized posture at NixOS, CLAB, and OpenConfig canonical inputs. Complete OpenConfig model coverage remains a separate false limitation.";
    liveDeviceClaimed = false;
  };
}
