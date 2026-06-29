{
  layer = "SIT";
  traceId = "FS-720-HDS-030-SDS-010";
  smsInputs = {
    "FS-720-HDS-030-SDS-010-SMS-021" = {
      smtRow = ../../SMT/FS-720-HDS-030-SDS-010-SMS-021;
      sourcePath = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-021/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-030-SDS-010-SMS-021-ae-cpm-only-consumption.md";
      role = "access-endpoint-cpm-only-consumption";
      evidenceBoundary = "owning-renderer-construction-plus-live-endpoint-materialization";
    };
    "FS-720-HDS-030-SDS-010-SMS-041" = {
      smtRow = ../../SMT/FS-720-HDS-030-SDS-010-SMS-041;
      sourcePath = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-041/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-030-SDS-010-SMS-041-ae-fail-closed-contract.md";
      role = "active-lab-tenant-bridge-source-fixture";
      evidenceBoundary = "owning-renderer-construction-plus-live-clab-render-status";
    };
  };
  evidence = {
    command = ''
      bash tests/FS-720-HDS-030-SDS-010-SMS-041-active-lab-tenant-bridge-source.sh &&
      bash tests/FS-720-HDS-030-SDS-010-SMS-041-SIT-live-clab-render-status.sh s-router-clab &&
      (cd ../network-renderer-access-endpoint-nixos &&
        NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-720-HDS-030-SDS-010-SMS-021.sh &&
        NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-720-HDS-030-SDS-010-SMS-041.sh) &&
      (cd ../network-renderer-containerlab-linux-backend &&
        NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs720-hds030-sds010-sms041-wan-host-uplink-bridge.sh) &&
      (cd ../network-codex-agent &&
        scripts/fs720-active-lab-endpoint-clab-runtime-check.sh --live)
    '';
    observedResult = "OK live on 2026-06-29: SMS-021 and SMS-041 owning access-endpoint renderer construction tests pass, CLAB renderer explicit bridge-field test passes, active-lab tenant bridge source fixture passes, s-router-clab render-live status is phase=complete/result=success, and network-codex-agent@616d8272 FS-720 live verifier passes against s-router-clab and s-router-test-clients endpoint containers/bridges";
  };
}
