{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-101";
  miniSmtId = "FS-370-HDS-010-SDS-010-SMS-101";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-370-HDS-010-SDS-010-SMS-101__mini-policy-ds-return-path"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-101";
    focusedTest = null;
    maxRuntimeTargets = 3;
    scope = "Policy/DS per-lane return-path routing: policy node uses lane-table return routes instead of ECMP main-table routes for symmetric return path";
  };
}
