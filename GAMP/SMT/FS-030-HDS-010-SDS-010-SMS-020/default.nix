{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-010-SMS-020";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-010-SMS-020__mini-verify"
    ];
  };
  evidence = {
    focusedTest = "tests/FS-030-HDS-010-SDS-010-SMS-020-cpm-realization-binder-source-audit.sh";
    owningRepo = "network-control-plane-model";
    maxRuntimeTargets = 5;
    scope = "CPM realization binder authority boundary: prevents inventory from creating unauthorized behavior and proves row-local mini-SMT artifacts";
  };
}
