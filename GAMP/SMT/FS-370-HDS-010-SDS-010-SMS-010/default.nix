{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-010-source-prefix-egress-surface.md";
  titleSlug = "source-prefix-egress-surface";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-010__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-control-plane-model";
    focusedTest = "tests/test-fs370-hds010-sds010-sms010-source-prefix-egress.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-010";
    smtRow = "GAMP/SMT/README.md row 63";
    status = "OK";
    verifiedAt = "network-control-plane-model local HEAD c1137cd (2026-07-02)";
    scope = "source-prefix egress surface binding predicate: CPM internetModes and forwardingIntent carry source prefix, source scope, lane, candidate egress, return-route, and leak-prevention metadata; unscoped egress accept, routed-public IPv4 without return routes, and missing leak prevention fail closed. Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
