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
    command = "bash tests/test-fs310-hds010-sds010-sms030-policy-router-relation-identity-row-local.sh";
    focusedTest = "tests/test-fs310-hds010-sds010-sms030-policy-router-relation-identity-row-local.sh";
    maxRuntimeTargets = 2;
    scope = "one tenant-to-external allow relation through policy router with relation identity preservation";
  };
}
