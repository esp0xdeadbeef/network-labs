{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-030";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-030-host-only-source-prefix-denial.md";
  titleSlug = "host-only-source-prefix-denial";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ "FS-370-HDS-010-SDS-010-SMS-030__mini-verify" ];
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-030";
    smtRow = "GAMP/SMT/README.md row 228";
    status = "OK";
    verifiedAt = "network-forwarding-model local HEAD b3012dd plus working tree (2026-07-02)";
    scope = "host-only source-prefix denial: classifies IPv4 /32 and IPv6 /128 source-file authorities as host-only-provider-prefix, preserves prefix-authority records, and denies downstream export while leaving modeled routed-public-ipv4 semantics intact (construction-only, NFM-owned). Active-lab live script currently reports host artifact context and does not promote runtime acceptance.";
  };
}
