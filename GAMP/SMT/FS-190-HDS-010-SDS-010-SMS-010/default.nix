{
  layer = "SMT";
  traceId = "FS-190-HDS-010-SDS-010-SMS-010";
  miniSmtId = "FS-190-HDS-010-SDS-010-SMS-010";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [ ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-190-HDS-010-SDS-010-SMS-010";
    focusedTest = "tests/test-active-lab-mini-smt-service-exposure-classification-only.sh";
    maxRuntimeTargets = 2;
    scope = "one service with explicit exposureClass=shared-local: classification record emitted, seeded negatives for missing exposure class and inferred exposure";
  };
}
