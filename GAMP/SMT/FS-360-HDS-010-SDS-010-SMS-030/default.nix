{
  layer = "SMT";
  traceId = "FS-360-HDS-010-SDS-010-SMS-030";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-360-HDS-010-SDS-010-SMS-030-gua-transit-placement-validation.md";
  titleSlug = "gua-transit-placement-validation";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-360-HDS-010-SDS-010-SMS-030__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/fs-360-hds-010-sds-010-sms-030.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-360-HDS-010-SDS-010-SMS-030";
    smtRow = "GAMP/SMT/README.md row 226";
    status = "OK";
    verifiedAt = "network-labs + network-forwarding-model local HEAD (2026-07-02)";
    scope = "GUA transit placement precondition validation; construction-only, NFM-owned. Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
