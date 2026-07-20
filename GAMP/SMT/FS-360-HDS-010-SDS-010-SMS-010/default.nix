{
  layer = "SMT";
  traceId = "FS-360-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-360-HDS-010-SDS-010-SMS-010-downstream-client-public-prefix-authority.md";
  titleSlug = "downstream-client-public-prefix-authority";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-360-HDS-010-SDS-010-SMS-010__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    smtRow = "GAMP/SMT/README.md row 135";
    status = "OK";
    verifiedAt = "network-codex-agent + network-forwarding-model local HEAD (2026-07-02)";
    scope = "downstream client public prefix authority classification: consumes routed, delegated, tunneled, provider-owned, WAN, uplink, host-only, and non-delegating upstream prefix facts; emits classed prefix-authority records and consumer-eligibility decisions; denies host-only, WAN, uplink, and non-delegating upstream facts as downstream client public prefix authority (construction-only, NFM-owned)";
  };
}
