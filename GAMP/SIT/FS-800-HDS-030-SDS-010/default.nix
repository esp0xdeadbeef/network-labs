{
  layer = "SIT";
  traceId = "FS-800-HDS-030-SDS-010";
  smsInputs = {
    "FS-800-HDS-030-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-800-HDS-030-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-010-SMS-010-pppoe-provider-side.md";
      role = "pppoe-provider-side-source-fixture";
      evidenceBoundary = "source-fixture-cpm-renderer-integration-plus-live-session-probe";
    };
  };
  evidence = {
    observedResult = "OK live on 2026-06-29: focused network-labs source test, CPM service-interface contract, CLAB renderer target-host bridge-scope test, CLAB renderer PPPoE artifact/link test, and bash tests/FS-800-HDS-030-SDS-010-SIT-live-pppoe-session-markers.sh pass; active-lab s-router-nixos and s-router-clab expose provider/customer PPPoE records and provider-side PPPoE server/runtime processes are active";
  };
}
