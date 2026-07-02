{
  layer = "SMT";
  traceId = "FS-360-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-360-HDS-010-SDS-010-SMS-020-public-prefix-return-route-precondition.md";
  titleSlug = "public-prefix-return-route-precondition";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-360-HDS-010-SDS-010-SMS-020__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/fs-360-hds-010-sds-010-sms-020.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-360-HDS-010-SDS-010-SMS-020";
    smtRow = "GAMP/SMT/README.md row 225";
    status = "OK";
    verifiedAt = "network-labs + network-forwarding-model local HEAD (2026-07-02)";
    scope = "public prefix return-route precondition validation for GUA placement authority; construction-only, NFM-owned. Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
