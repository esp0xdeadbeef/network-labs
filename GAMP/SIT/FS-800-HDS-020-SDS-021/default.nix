{
  layer = "SIT";
  traceId = "FS-800-HDS-020-SDS-021";
  smsInputs = {
    "FS-800-HDS-020-SDS-021-SMS-010" = {
      smtRow = ../../SMT/FS-800-HDS-020-SDS-021-SMS-010;
      sourcePath = "GAMP/SMT/FS-800-HDS-020-SDS-021-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
