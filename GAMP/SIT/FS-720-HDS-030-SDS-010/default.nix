{
  layer = "SIT";
  traceId = "FS-720-HDS-030-SDS-010";
  smsInputs = {
    "FS-720-HDS-030-SDS-010-SMS-021" = {
      smtRow = ../../SMT/FS-720-HDS-030-SDS-010-SMS-021;
      sourcePath = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-021/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-030-SDS-010-SMS-021-ae-cpm-only-consumption.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-720-HDS-030-SDS-010-SMS-041" = {
      smtRow = ../../SMT/FS-720-HDS-030-SDS-010-SMS-041;
      sourcePath = "GAMP/SMT/FS-720-HDS-030-SDS-010-SMS-041/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-030-SDS-010-SMS-041-ae-fail-closed-contract.md";
      role = "active-lab-tenant-bridge-source-fixture";
      evidenceBoundary = "active-lab-source-fixture-only";
    };
  };
  evidence = {
    command = ''
      bash tests/FS-720-HDS-030-SDS-010-SMS-041-active-lab-tenant-bridge-source.sh &&
      bash tests/FS-720-HDS-030-SDS-010-SMS-041-SIT-live-clab-render-status.sh s-router-clab
    '';
    observedResult = "NOT OK live on 2026-06-29: source fixture test passes for active-lab tenant bridge fields, but s-router-clab render-live status is phase=render/result=failure and journal shows duplicate br-wan target-host bridge scoping before locked artifact acceptance";
  };
}
