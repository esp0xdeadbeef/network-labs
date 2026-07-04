{
  layer = "SIT";
  traceId = "FS-060-HDS-010-SDS-010";
  smsInputs = {
    "FS-060-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-060-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-060-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-060-HDS-010-SDS-010-SMS-010-runtime-fact-boundary.md";
      role = "runtime-fact-boundary-mini-path";
      evidenceBoundary = "source-stub-plus-live-script";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-060-HDS-010-SDS-010-SMS-010";
    liveCommand = ''
      cd /home/deadbeef/github/network-codex-agent &&
      S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-060-HDS-010-SDS-010 \
      bash scripts/s-router-full-lab-rebuild-loop.sh s-router-nixos
    '';
    observedResult = "SIT parent row selects the FS-060-HDS-010-SDS-010-SMS-010 runtime-fact mini path and must be closed by the network-codex-agent parent live wrapper scripts/sit-live-FS-060-HDS-010-SDS-010.sh. The live wrapper writes parent trace evidence under /tmp/s-router-live-smoke/FS-060-HDS-010-SDS-010 while reusing the child full-trace artifact checks for s-router-nixos, s-router-clab, and s-router-test-clients.";
  };
}
