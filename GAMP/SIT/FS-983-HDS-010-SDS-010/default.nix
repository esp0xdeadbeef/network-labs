{
  layer = "SIT";
  traceId = "FS-983-HDS-010-SDS-010";
  smsInputs = {
    "FS-983-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-983-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-983-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-983-HDS-010-SDS-010-SMS-010-renderer-endpoint-fixture-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
