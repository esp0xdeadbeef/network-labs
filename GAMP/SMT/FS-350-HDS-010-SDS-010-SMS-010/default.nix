{
  layer = "SMT";
  traceId = "FS-350-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = null;
  };
  evidence = {
    owningRepo = "network-forwarding-model";
    smtRow = "GAMP/SMT/README.md row pending";
    status = "OK";
    verifiedAt = "network-labs HEAD (2026-06-27)";
    scope = "prefix subdivision authority: source authority consumption, deterministic child prefix derivation, subdivision plan emission with authority reference, missing-source-authority rejection, ambiguous-child-purpose rejection, missing-authority-reference rejection";
  };
}
