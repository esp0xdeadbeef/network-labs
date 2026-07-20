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
    maxRuntimeTargets = 2;
    scope = "one service with explicit exposureClass=shared-local: classification record emitted, seeded negatives for missing exposure class and inferred exposure";
  };
}
