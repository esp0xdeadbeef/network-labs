{
  layer = "SMT";
  traceId = "FS-500-HDS-010-SDS-010-SMS-030";
  miniSmtId = "decision-reason-diagnostic";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-500-HDS-010-SDS-010-SMS-030__mini-decision-reason-diagnostic"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh decision-reason-diagnostic";
    focusedTest = "tests/test-active-lab-mini-smt-decision-reason-diagnostic-only.sh";
    maxRuntimeTargets = 2;
    scope = "one reachability decision relation and traffic-path validation reason diagnostics";
  };
}
