{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-010-SMS-040";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-010-SMS-040__mini-verify"
    ];
  };
  evidence = {
    owningRepo = "network-control-plane-model";
    focusedTest = "tests/FS-030-HDS-010-SDS-010-SMS-020-cpm-realization-binder-source-audit.sh";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-010-SMS-040";
    status = "OK";
    maxRuntimeTargets = 5;
    scope = "CPM binder source audit: ensures every CPM realization-binding field carries a binder source-class audit reference plus upstream behavior reference, fails closed on missing or cross-stage audit records";
  };
}
