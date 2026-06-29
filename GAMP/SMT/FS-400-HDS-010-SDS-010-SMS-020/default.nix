{
  layer = "SMT";
  traceId = "FS-400-HDS-010-SDS-010-SMS-020";
  miniSmtId = "ula-nat66-selection";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-400-HDS-010-SDS-010-SMS-020__mini-ula-nat66-tenant-to-wan"
    ];
  };
  evidence = {
    command = "bash tests/test-fs400-hds010-sds010-sms020-ula-nat66-intent-fixture.sh";
    focusedTest = "tests/test-fs400-hds010-sds010-sms020-ula-nat66-intent-fixture.sh";
    maxRuntimeTargets = 0;
    scope = "ULA NAT66 selection validation: CPM diagnostics for missing egress authority and untranslated ULA routing";
  };
}
