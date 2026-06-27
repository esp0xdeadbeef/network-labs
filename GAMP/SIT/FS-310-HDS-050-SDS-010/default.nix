{
  layer = "SIT";
  traceId = "FS-310-HDS-050-SDS-010";
  smsInputs = {
    "FS-310-HDS-050-SDS-010-SMS-220" = {
      smtRow = ../../SMT/FS-310-HDS-050-SDS-010-SMS-220;
      sourcePath = "GAMP/SMT/FS-310-HDS-050-SDS-010-SMS-220/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-050-SDS-010-SMS-220-test-input-pinning.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
