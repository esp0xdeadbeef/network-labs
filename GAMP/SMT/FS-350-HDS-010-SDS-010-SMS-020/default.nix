{
  layer = "SMT";
  traceId = "FS-350-HDS-010-SDS-010-SMS-020";
  evidenceBoundary = "construction-only";
  source = {
    kind = "source-reference";
    intent = null;
    expectedRelationIds = null;
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/test-fs350-prefix-authority-consumer-eligibility.sh";
    smtRow = "GAMP/SMT/README.md row 220";
    status = "OK";
    verifiedAt = "NFM HEAD (2026-06-05), re-verified 2026-06-27";
    scope = "reserved prefix denial: consumes reservation state, denies reserved/unassigned prefix consumers with reserved-prefix-authority and unassigned-prefix-authority diagnostics, blocks advertisement/route/translation/assignment/exposure (construction-only)";
  };
}
