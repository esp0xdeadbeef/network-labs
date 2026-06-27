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
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
