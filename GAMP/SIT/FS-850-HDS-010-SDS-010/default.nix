{
  layer = "SIT";
  traceId = "FS-850-HDS-010-SDS-010";
  smsInputs = {
    "FS-850-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-850-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-850-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-850-HDS-010-SDS-010-SMS-010-secret-redaction.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-850-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-850-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-850-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-850-HDS-010-SDS-010-SMS-020-redacted-correlation-preservation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-850-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-850-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-850-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-850-HDS-010-SDS-010-SMS-030-secret-bearing-output-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
