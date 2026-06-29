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
    command = ''
      network_labs_path="''${PWD}";
      bash tests/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-source.sh &&
      (cd ../network-codex-agent && bash tests/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-record-checks.sh) &&
      (cd ../network-control-plane-model && NETWORK_LABS_PATH="''${network_labs_path}" NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-800-HDS-030-SDS-010-SMS-010-pppoe-service-interface-contract.sh) &&
      (cd ../network-renderer-containerlab-linux-backend &&
        NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs800-hds030-sds010-sms010-target-host-bridge-scope.sh &&
        NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs800-hds030-sds010-sms010-pppoe-artifacts.sh) &&
      bash tests/FS-800-HDS-030-SDS-020-SIT-live-pppoe-session-markers.sh
    '';
    observedResult = "OK live on 2026-06-29: S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs800-pppoe-hat-active-lab-runtime-check.sh --live PASS on the active HAT lab. The run passes the network-labs customer-side source fixture, network-codex-agent customer-side record check, CPM service-interface contract, CLAB renderer bridge/artifact fixtures, live SOPS recipient/decrypt checks, live secret materialization, provider-side runtime, customer-side runtime, and CLAB render marker. NixOS renderer fixes network-renderer-nixos@55727d3 and @f763a1d make the PPPoE client start non-blocking and timer-delayed until container host bridge attachment; running s-router-nixos generation /nix/store/r347n2c5lwwbhc2l9rpzw82a058parzz-nixos-system-s-router-nixos-26.05.20260627.714a5f8 shows ppp0 203.0.113.4/32 and ppp1 203.0.113.2 peer 203.0.113.1/32 live";
  };
}
