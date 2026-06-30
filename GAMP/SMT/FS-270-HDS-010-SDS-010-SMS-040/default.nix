{
  layer = "SMT";
  traceId = "FS-270-HDS-010-SDS-010-SMS-040";
  miniSmtId = "FS-270-HDS-010-SDS-010-SMS-040";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-270-HDS-010-SDS-010-SMS-040__mini-selector-handoff-client-to-testnet"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh --source FS-270-HDS-010-SDS-010-SMS-040";
    focusedTest = "tests/FS-270-HDS-010-SDS-010-SMS-040-selector-forwarding-relation-identity.sh";
    owningRepo = "network-control-plane-model";
    maxRuntimeTargets = 2;
    scope = "selector handoff transport forwarding boundary: one access router with tenant client, one core router with uplink; validates CPM emits only modeled selector forwarding with relation identity";
    smtRow = "GAMP/SMT/README.md row 468";
    status = "NOT OK";
    verifiedAt = "network-control-plane-model@235432c (2026-06-07 locked proof)";
  };
}
