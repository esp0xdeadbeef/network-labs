{
  layer = "SIT";
  traceId = "FS-080-HDS-010-SDS-010";
  smsInputs = {
    "FS-080-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-080-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-080-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-080-HDS-010-SDS-010-SMS-010-missing-ambiguous-fact-failure.md";
      role = "missing-ambiguous-fact-failure-mini-path";
      evidenceBoundary = "runtime";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-080-HDS-010-SDS-010-SMS-010";
    liveCommand = ''
      cd /home/deadbeef/github/network-codex-agent &&
      S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-080-HDS-010-SDS-010-SMS-010 \
      RUN_NETWORK_REPO_TESTS=0 \
      RUN_CONTAINERLAB_TESTS=0 \
      LAUNCH_HETZNER_MACHINE=0 \
      REBOOT_S_ROUTER_TEST_CLIENTS=1 \
      RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 \
      NETWORK_REPO_DIRECT_TEST_OK=1 \
      MINI_SMT_OFFLINE_VERIFY=0 \
      bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos
    '';
    observedResult = "OK live on 2026-07-04: locked source /nix/store/1ncva3xfxmr7bv4yb8i136zb541y9j17-source selected full SMS trace FS-080-HDS-010-SDS-010-SMS-010 and full-loop active-lab evidence /tmp/s-router-live-smoke/FS-080-HDS-010-SDS-010-SMS-010/20260704T084107Z plus /tmp/s-router-live-smoke/FS-080-HDS-010-SDS-010-SMS-010/20260704T084201Z passed. s-router-clab active-lab readiness reported active-targets=5. The child full-trace artifact checks verified five bounded runtime targets on s-router-nixos and s-router-clab, zero router runtime targets on s-router-test-clients, requiredFactViolationRecords=0, downstreamRepairRecords=0, unknownSourceClassRecords=0, and relationHits=38 on both router hosts. Construction proof `bash tests/test-gamp-sms-input-contracts.sh` confirmed missing facts, ambiguous facts, unknown source class, downstream continuation, and defaulted/inferred values are rejected. This is SMT/SIT live evidence only, not HAT/SAT or production readiness.";
  };
}
