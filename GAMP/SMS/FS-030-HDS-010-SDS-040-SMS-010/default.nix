{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-040-SMS-010";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-040;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-040-SMS-010-platform-independence-contract.md";
  titleSlug = "platform-independence-contract";
  purpose = "Active row-local mini-SMT input template for compiler platform independence.";
  evidenceBoundary = "row-local-mini-smt";
  sourceInputs = {
    "FS-030-HDS-010-SDS-040-SMS-010" = {
      traceId = "FS-030-HDS-010-SDS-040-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-040-SMS-010/intent.nix";
      constructionTest = "network-compiler/tests/test-FS-030-HDS-010-SDS-040-SMS-010.sh";
      liveWrapper = "network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-040-SMS-010.sh";
      test = "tests/run-active-lab-mini-smt.sh";
      maxRuntimeTargets = 5;
    };
  };
  templateTests = [
    "tests/run-active-lab-mini-smt.sh"
    "network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-040-SMS-010.sh"
    "network-compiler/tests/test-FS-030-HDS-010-SDS-040-SMS-010.sh"
  ];
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-030-HDS-010-SDS-040-SMS-010.sh";
    observedResult = "2026-07-04 compiler construction test and live mini-SMT runtime wrapper passed for platform-independent output, renderer selector rejection, bridge-name rejection, substrate technology selector rejection, and output leak seeded negatives";
    liveCommand = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010";
    evidenceDirs = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053321Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053649Z"
      "/tmp/active-lab-mini-smt-runs/20260704T053642Z-2913672/FS-030-HDS-010-SDS-040-SMS-010"
    ];
  };
}
