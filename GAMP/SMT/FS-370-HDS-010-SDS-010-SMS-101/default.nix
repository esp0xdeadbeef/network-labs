{
  layer = "SMT";
  traceId = "FS-370-HDS-010-SDS-010-SMS-101";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-101-policy-ds-per-lane-return-path-routing.md";
  miniSmtId = "FS-370-HDS-010-SDS-010-SMS-101";
  titleSlug = "policy-ds-per-lane-return-path-routing";
  evidenceBoundary = "split";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-370-HDS-010-SDS-010-SMS-101__mini-policy-ds-return-path"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-101";
    owningRepo = "network-control-plane-model";
    focusedTest = "tests/FS-370-HDS-010-SDS-010-SMS-101-per-lane-return-path-routing.sh";
    activeLabContext = "tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-101";
    smtRow = "GAMP/SMT/README.md row 513";
    status = "OK";
    verifiedAt = "network-control-plane-model local HEAD c1137cd plus working tree (2026-07-02)";
    maxRuntimeTargets = 3;
    scope = "Policy/DS per-lane return-path routing: CPM emits and guards lane-table return routes for egress-bearing policy/DS access lanes, with active seeded negatives for wrong-lane and missing return-path diagnostics. Active-lab context currently reports host artifact context and does not promote runtime packet acceptance.";
  };
}
