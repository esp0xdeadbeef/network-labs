{
  layer = "SMT";
  traceId = "FS-320-HDS-010-SDS-010-SMS-010";
  miniSmtId = "renderer-layout-preservation";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-320-HDS-010-SDS-010-SMS-010__mini-client-to-testnet-allow"
      "FS-320-HDS-010-SDS-010-SMS-010__mini-mgmt-deny-internet"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh renderer-layout-preservation";
    focusedTest = "tests/test-active-lab-mini-smt-renderer-layout-preservation-only.sh";
    maxRuntimeTargets = 2;
    scope = "two-node co-located layout: access node hosts client+mgmt tenants; core exit with testnet uplink; verifies role identity and policy boundary preservation";
  };
}
