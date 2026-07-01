{
  layer = "SIT";
  traceId = "FS-720-HDS-010-SDS-020";
  smsInputs = {
    "FS-720-HDS-010-SDS-020-SMS-020" = {
      smtRow = ../../SMT/FS-720-HDS-010-SDS-020-SMS-020;
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-020/intent.nix";
      role = "endpoint-harness-consumption";
      evidenceBoundary = "construction-only";
    };
    "FS-720-HDS-010-SDS-020-SMS-040" = {
      smtRow = ../../SMT/FS-720-HDS-010-SDS-020-SMS-040;
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-040/intent.nix";
      role = "test-clients-persistence-management";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "cd ../network-codex-agent && NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-s-router-fs720-source-harness-integration.sh";
    sourcePaths = [
      "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-020/intent.nix"
      "GAMP/SMT/FS-720-HDS-010-SDS-020-SMS-040/intent.nix"
    ];
    observedResult = "2026-07-01 construction/source-artifact proof PASS at network-codex-agent@d7f20211: /tmp/hat-sat-agent-fs720-sit-source-harness-integration-high/run.Gp2DgG. FS-720-HDS-010-SDS-020-SMS-020 is construction-only and intentionally not registered in GAMP/SMT/mini-smt/tests.nix.";
  };
}
