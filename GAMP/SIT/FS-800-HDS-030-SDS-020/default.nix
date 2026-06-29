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
    observedResult = "NOT OK live on 2026-06-29: focused network-labs source test, network-codex-agent customer-side record check, CPM service-interface contract, CLAB renderer target-host bridge-scope test, and CLAB renderer PPPoE artifact/link test pass; bash tests/FS-800-HDS-030-SDS-020-SIT-live-pppoe-session-markers.sh fails on active-lab because nixos-core-testnet-host-isp is stuck activating after a targeted start attempt, nixos-core-testnet-routed-isp is inactive, and the NixOS customer PPPoE session is not established; CLAB customer-side PPPoE is active";
  };
}
