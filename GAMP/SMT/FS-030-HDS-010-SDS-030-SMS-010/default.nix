{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-030-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-030-SMS-010-overlay-underlay-separation.md";
  titleSlug = "overlay-underlay-separation";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-030-SMS-010__overlay-payload"
      "FS-030-HDS-010-SDS-030-SMS-010__overlay-underlay"
      "FS-030-HDS-010-SDS-030-SMS-010__underlay-access-egress"
    ];
  };
  status = "OK";
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-030-SMS-010";
    owningRepo = "network-compiler";
    focusedTest = "tests/test-FS-030-HDS-010-SDS-030-SMS-010.sh";
    maxRuntimeTargets = 6;
    observedResult = "2026-07-04 live mini-SMT passed: compiler construction predicates passed, offline verifier was skipped, s-router-nixos and s-router-clab each emitted and enumerated six full-trace runtime targets, s-router-test-clients emitted zero runtime targets, and pinned s-router-nixos build passed";
    evidenceDirs = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051250Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051319Z"
      "/tmp/active-lab-mini-smt-runs/20260704T051312Z-2891933/FS-030-HDS-010-SDS-030-SMS-010"
    ];
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-030-SMS-010";
    scope = "Compiler overlay-underlay separation: enforces distinct policy relations with separate p2pIsolationKey per overlay leg, requires explicit underlayAccess declarations, emits forbidsCoreToCoreP2P and overlay/peer-site identity";
  };
}
