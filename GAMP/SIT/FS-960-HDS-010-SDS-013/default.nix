{
  layer = "SIT";
  traceId = "FS-960-HDS-010-SDS-013";
  smsInputs = {
    "FS-960-HDS-010-SDS-013-SMS-010" = {
      smtRow = ../../SMT/FS-960-HDS-010-SDS-013-SMS-010;
      sourcePath = "GAMP/SMT/FS-960-HDS-010-SDS-013-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-960-HDS-010-SDS-013-SMS-010-marker-wait-ordering.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
