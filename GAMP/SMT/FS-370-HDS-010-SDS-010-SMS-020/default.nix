{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-020-overlay-source-prefix-identity-binding.md";
  titleSlug = "overlay-source-prefix-identity-binding";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-020__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/fs-370-hds-010-sds-010-sms-020.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-020";
    smtRow = "GAMP/SMT/README.md row 227";
    status = "OK";
    verifiedAt = "network-forwarding-model local HEAD b3012dd plus working tree (2026-07-02)";
    scope = "overlay source-prefix identity binding: preserves tenant owner and overlay lane metadata, rejects explicit unbound overlay prefixes, and rejects conflicting prefix owners with active seeded negatives (construction-only, NFM-owned). Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
