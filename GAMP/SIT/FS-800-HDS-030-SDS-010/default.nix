{
  layer = "SIT";
  traceId = "FS-800-HDS-030-SDS-010";
  smsInputs = {
    "FS-800-HDS-030-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-800-HDS-030-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-010-SMS-010-pppoe-provider-side.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
