{
  layer = "SMT";
  traceId = "FS-800-HDS-030-SDS-030-SMS-010";
  miniSmtId = "FS-800-HDS-030-SDS-030-SMS-010";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-800-HDS-030-SDS-030-SMS-010__mini-pppoe-client-to-provider"
    ];
  };
  evidence = {
    maxRuntimeTargets = 5;
    scope = "PPPoE provider/customer pairing and fallback rejection";
  };
}
