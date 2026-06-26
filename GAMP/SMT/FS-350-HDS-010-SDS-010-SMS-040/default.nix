{
  layer = "SMT";
  traceId = "FS-350-HDS-010-SDS-010-SMS-040";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = null;
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    focusedTest = "tests/test-FS-350-HDS-010-SDS-010-SMS-040-prefix-authority-class-separation.sh";
    smtRow = "GAMP/SMT/README.md row pending";
    status = "OK";
    verifiedAt = "network-labs HEAD (2026-06-27)";
    scope = "prefix authority class separation: authorityClass assignment, childPurpose derivation, consumer eligibility checks, invalid-consumer-for-authority-class rejection, reserved-space denial, unassigned-space rejection";
  };
}
