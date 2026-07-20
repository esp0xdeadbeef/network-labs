{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-100";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-100-upstream-selector-shared-iface-ip-rule-priority.md";
  titleSlug = "upstream-selector-shared-iface-ip-rule-priority";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-100__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-100";
    smtRow = "GAMP/SMT/README.md row 512";
    status = "OK";
    verifiedAt = "network-forwarding-model local HEAD b3012dd plus working tree (2026-07-02)";
    scope = "shared-interface policy routing priority: proves lane metadata, route direction, policy structure, and active fail-closed diagnostics for return-direction shared-interface default catch-all plus priority inversion capture (construction-only, NFM-owned). Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
