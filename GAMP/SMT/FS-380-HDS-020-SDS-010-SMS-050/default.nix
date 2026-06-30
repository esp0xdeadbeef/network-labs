{
  layer = "SMT";
  traceId = "FS-380-HDS-020-SDS-010-SMS-050";
  miniSmtId = "FS-380-HDS-020-SDS-010-SMS-050";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-380-HDS-020-SDS-010-SMS-050__mini-client-to-emulated-isp"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-380-HDS-020-SDS-010-SMS-050";
    focusedTest = "tests/test-active-lab-mini-smt-internet-mode-verification-only.sh";
    maxRuntimeTargets = 2;
    scope = "SMT/SIT-only internet mode verification: tenant client reaches an emulated PPPoE provider; provider upstream is VLAN4/VLAN5 DHCP only; skips, NAT, and VLAN2 are rejected";
  };
}
