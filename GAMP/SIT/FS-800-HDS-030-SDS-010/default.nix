{
  layer = "SIT";
  traceId = "FS-800-HDS-030-SDS-010";
  smsInputs = {
    "FS-800-HDS-030-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-800-HDS-030-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-010-SMS-010-pppoe-provider-side.md";
      role = "pppoe-provider-side-source-fixture";
      evidenceBoundary = "source-fixture-cpm-renderer-integration-only";
    };
  };
  evidence = {
    command = ''
      network_labs_path="''${PWD}";
      bash tests/FS-800-HDS-030-SDS-010-SMS-010-pppoe-provider-side-source.sh &&
      (cd ../network-control-plane-model && NETWORK_LABS_PATH="''${network_labs_path}" NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-800-HDS-030-SDS-010-SMS-010-pppoe-service-interface-contract.sh) &&
      (cd ../network-renderer-containerlab-linux-backend && NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs800-hds030-sds010-sms010-pppoe-artifacts.sh)
    '';
    observedResult = "focused network-labs source test plus CPM service-interface contract plus CLAB renderer PPPoE artifact/link test verify provider-side PPPoE records compile into explicit pppoe-handoff interfaces and render an actual Containerlab bridge link; does not claim live HAT/SAT session acceptance";
  };
}
