{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-070";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-070-core-forwarding-chain.md";
  titleSlug = "core-forwarding-chain";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-070__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/fs-370-hds-010-sds-010-sms-070.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-070";
    smtRow = "GAMP/SMT/README.md row 527";
    status = "OK";
    verifiedAt = "network-forwarding-model local HEAD b3012dd plus working tree (2026-07-02)";
    scope = "core forwarding chain: proves core route presence, tenant return-path internal-reachability, complete five-stage fabric identity, and upstream/core role metadata (construction-only, NFM-owned). Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
