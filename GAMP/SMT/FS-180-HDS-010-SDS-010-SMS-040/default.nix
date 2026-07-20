{
  layer = "SMT";
  traceId = "FS-180-HDS-010-SDS-010-SMS-040";
  miniSmtId = "FS-180-HDS-010-SDS-010-SMS-040";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-180-HDS-010-SDS-010-SMS-040__mini-verify"
    ];
  };
  evidence = {
    maxRuntimeTargets = 2;
    scope = "one symmetric relation with returnBehavior=symmetric: forward plus reverse nft accept rules";
  };
}
