{
  layer = "SMT";
  traceId = "FS-380-HDS-020-SDS-010-SMS-050";
  miniSmtId = "internet-mode-verification";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-380-HDS-020-SDS-010-SMS-050__mini-client-to-wan"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh internet-mode-verification";
    focusedTest = "tests/test-active-lab-mini-smt-internet-mode-verification-only.sh";
    maxRuntimeTargets = 2;
    scope = "renderer internet mode verification: tenant client to WAN external with privateNat44 source prefixes and output interfaces";
  };
}
