{
  layer = "SMT";
  traceId = "FS-720-HDS-010-SDS-020-SMS-020";
  miniSmtId = "endpoint-harness-consumption";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-720-HDS-010-SDS-020-SMS-020__mini-client-harness-consumption"
    ];
  };
  evidenceBoundary = "construction-only";
  evidence = {
    command = "cd ../network-codex-agent && NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-720-HDS-010-SDS-020-SMS-020.sh";
    focusedTest = "../network-codex-agent/tests/FS-720-HDS-010-SDS-020-SMS-020.sh";
    maxRuntimeTargets = 3;
    status = "OK";
    observedResult = "2026-07-01 construction proof PASS at network-codex-agent@d7f20211: /tmp/fs720-sds020-sms020-harness-consumption/run.cR20UO. This row is a construction-only source stub and is intentionally not registered as an active-lab mini runtime shim.";
    scope = "Prepared source fixture for s-router-test-clients endpoint harness consumption; owning proof is the network-codex-agent construction harness, not tests/run-active-lab-mini-smt.sh.";
  };
}
