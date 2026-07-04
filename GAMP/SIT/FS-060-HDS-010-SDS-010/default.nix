{
  layer = "SIT";
  traceId = "FS-060-HDS-010-SDS-010";
  smsInputs = {
    "FS-060-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-060-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-060-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-060-HDS-010-SDS-010-SMS-010-runtime-fact-boundary.md";
      role = "runtime-fact-boundary-mini-path";
      evidenceBoundary = "runtime";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-060-HDS-010-SDS-010-SMS-010";
    liveCommand = ''
      cd /home/deadbeef/github/network-codex-agent &&
      S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-060-HDS-010-SDS-010-SMS-010 \
      RUN_NETWORK_REPO_TESTS=0 \
      RUN_CONTAINERLAB_TESTS=0 \
      LAUNCH_HETZNER_MACHINE=0 \
      REBOOT_S_ROUTER_TEST_CLIENTS=1 \
      RUN_S_ROUTER_CLAB_REBUILD_LOOP=1 \
      NETWORK_REPO_DIRECT_TEST_OK=1 \
      MINI_SMT_OFFLINE_VERIFY=0 \
      bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos
    '';
    observedResult = "OK live on 2026-07-04: locked source /nix/store/8m09agpz5bbqdcfyf1gvpayg7v1sl3lx-source selected full SMS trace FS-060-HDS-010-SDS-010-SMS-010 and full-loop active-lab evidence /tmp/s-router-live-smoke/FS-060-HDS-010-SDS-010-SMS-010/20260704T072157Z plus /tmp/s-router-live-smoke/FS-060-HDS-010-SDS-010-SMS-010/20260704T072252Z passed. s-router-clab active-lab readiness reported active-targets=5. The child full-trace artifact checks verified five bounded runtime targets on s-router-nixos and s-router-clab, zero router runtime targets on s-router-test-clients, CPM provider endpoint construction, and the CPM-to-NixOS-renderer boundary rejecting endpoint invention. Manual enumeration confirmed providerEndpointRecords=0 on all three hosts. This is SMT/SIT live evidence only, not HAT/SAT or production readiness.";
  };
}
