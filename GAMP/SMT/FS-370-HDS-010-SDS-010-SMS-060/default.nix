{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-060";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-060-access-node-tenant-internet-forwarding.md";
  titleSlug = "access-node-tenant-internet-forwarding";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-060__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/fs-370-hds-010-sds-010-sms-060.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-060";
    smtRow = "GAMP/SMT/README.md row 526";
    status = "OK";
    verifiedAt = "network-forwarding-model local HEAD b3012dd plus working tree (2026-07-02)";
    scope = "access-node tenant internet forwarding: proves default reachability toward downstream-selector, connected tenant reachability, non-null selector nexthop, and generated fabric-chain interfaces (construction-only, NFM-owned). Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
