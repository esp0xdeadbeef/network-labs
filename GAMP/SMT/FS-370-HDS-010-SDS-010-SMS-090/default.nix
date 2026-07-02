{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-090";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-090-core-return-path-routing.md";
  titleSlug = "core-return-path-routing";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-090__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/fs-370-hds-010-sds-010-sms-090.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-090";
    smtRow = "GAMP/SMT/README.md row 511";
    status = "OK";
    verifiedAt = "network-forwarding-model local HEAD b3012dd plus working tree (2026-07-02)";
    scope = "core return-path routing: proves tenant return route on core-to-upstream-selector fabric and active fail-closed diagnostics for missing return route and wrong return interface (construction-only, NFM-owned). Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
