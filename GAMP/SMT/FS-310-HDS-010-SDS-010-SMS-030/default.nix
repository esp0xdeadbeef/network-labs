{
  layer = "SMT";
  traceId = "FS-310-HDS-010-SDS-010-SMS-030";
  miniSmtId = "policy-router-relation-identity";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-310-HDS-010-SDS-010-SMS-030__mini-allow-client-to-testnet"
    ];
  };
  evidence = {
    maxRuntimeTargets = 2;
    scope = "one tenant-client to external-testnet allow relation with relation identity preservation";
  };
}
