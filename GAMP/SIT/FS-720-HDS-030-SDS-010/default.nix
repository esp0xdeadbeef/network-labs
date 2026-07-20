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
    observedResult = "OK live on 2026-06-29: SMS-021 and SMS-041 owning access-endpoint renderer construction tests pass, CLAB renderer explicit bridge-field test passes, active-lab tenant bridge source fixture passes, s-router-clab render-live status is phase=complete/result=success, and network-codex-agent@616d8272 FS-720 live verifier passes against s-router-clab and s-router-test-clients endpoint containers/bridges";
  };
}
