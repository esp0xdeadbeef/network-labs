{
  layer = "SIT";
  traceId = "FS-800-HDS-030-SDS-020";
  smsInputs = {
    "FS-800-HDS-030-SDS-020-SMS-010" = {
      smtRow = ../../SMT/FS-800-HDS-030-SDS-020-SMS-010;
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-record-checks.md";
      role = "pppoe-customer-side-source-fixture";
      evidenceBoundary = "source-fixture-cpm-renderer-integration-plus-live-session-probe";
    };
  };
  evidence = {
    observedResult = "OK live on 2026-06-29: S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/live-FS-800-HDS-030-SDS-030-SMS-010.sh --live PASS on the active HAT lab. The run passes the network-labs customer-side source fixture, network-codex-agent customer-side record check, CPM service-interface contract, CLAB renderer bridge/artifact fixtures, live SOPS recipient/decrypt checks, live secret materialization, provider-side runtime, customer-side runtime, and CLAB render marker. NixOS renderer fixes network-renderer-nixos@55727d3 and @f763a1d make the PPPoE client start non-blocking and timer-delayed until container host bridge attachment; running s-router-nixos generation /nix/store/r347n2c5lwwbhc2l9rpzw82a058parzz-nixos-system-s-router-nixos-26.05.20260627.714a5f8 shows ppp0 203.0.113.4/32 and ppp1 203.0.113.2 peer 203.0.113.1/32 live";
  };
}
