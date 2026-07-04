{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-030-SMS-010";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-030;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-030-SMS-010-overlay-underlay-separation.md";
  titleSlug = "overlay-underlay-separation";
  purpose = "Overlay-underlay separation row-local mini-SMT input.";
  evidenceBoundary = "row-local-mini-smt";
  sourceInputs = {
    "FS-030-HDS-010-SDS-030-SMS-010" = {
      traceId = "FS-030-HDS-010-SDS-030-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-030-SMS-010/intent.nix";
      test = "tests/run-active-lab-mini-smt.sh";
      maxRuntimeTargets = 6;
    };
  };
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-030-HDS-010-SDS-030-SMS-010.sh";
    observedResult = "2026-07-04 compiler construction test and live mini-SMT runtime wrapper passed for overlay identity, transport kind, peer-site identity, distinct p2pIsolationKey values, forbidsCoreToCoreP2P, and active seeded negatives";
    liveCommand = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-030-SMS-010";
    evidenceDirs = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051250Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051319Z"
      "/tmp/active-lab-mini-smt-runs/20260704T051312Z-2891933/FS-030-HDS-010-SDS-030-SMS-010"
    ];
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
