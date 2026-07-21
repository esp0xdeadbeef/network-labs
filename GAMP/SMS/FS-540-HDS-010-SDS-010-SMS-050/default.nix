{
  layer = "SMS";
  traceId = "FS-540-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-540-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-050-openconfig-dns-peer-posture.md";
  titleSlug = "openconfig-dns-peer-posture";
  purpose = "Canonical SMS mirror for deterministic renderer-peer construction.";
  evidenceBoundary = "construction";
  sourceInputs = {
    canonicalDnsBundle = {
      traceId = "FS-540-HDS-010-SDS-010-SMS-045";
      kind = "controlled-validation-scheme";
      sourcePath = "lib/validation-scheme.nix";
      maxRuntimeTargets = 0;
    };
  };
}
