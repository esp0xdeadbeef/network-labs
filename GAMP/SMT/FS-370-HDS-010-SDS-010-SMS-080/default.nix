{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-080";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-080-upstream-selector-default-route.md";
  titleSlug = "upstream-selector-default-route";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-080__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/fs-370-hds-010-sds-010-sms-080.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-080";
    smtRow = "GAMP/SMT/README.md row 510";
    status = "OK";
    verifiedAt = "network-forwarding-model local HEAD b3012dd plus working tree (2026-07-02)";
    scope = "upstream-selector default-route semantics: proves single selector-to-core default route and active fail-closed diagnostics for selector default bypass and missing selector default under non-overlay internet egress (construction-only, NFM-owned). Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
