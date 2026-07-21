{
  layer = "SMT";
  traceId = "FS-540-HDS-010-SDS-010-SMS-050";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-050-openconfig-dns-peer-posture.md";
  titleSlug = "openconfig-dns-peer-posture";
  source = {
    kind = "controlled-validation-scheme";
    canonicalBundleSource = "FS-540-HDS-010-SDS-010-SMS-045";
    implementation = "lib/validation-scheme.nix";
    entrypoint = "tests/FS-540-HDS-010-SDS-010-SMS-050.sh";
    evidenceBoundary = "construction";
  };
  status = "OK";
  evidence = {
    observedResult = "The deterministic validation scheme accepted one shared canonical DNS bundle for NixOS, CLAB, and OpenConfig, preserved the same normalized posture and bundle identity, recorded the pinned OpenConfig model limitation, emitted no reproducibility warning for the valid multi-egress selection, and rejected OC-DNS-N1 through OC-DNS-N10 with exit 2 and the exact required diagnostics before accepting the unchanged recovery input.";
  };
}
