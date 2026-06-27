{
  layer = "SIT";
  traceId = "FS-700-HDS-010-SDS-020";
  smsInputs = {
    "FS-700-HDS-010-SDS-020-SMS-010" = {
      smtRow = ../../SMT/FS-700-HDS-010-SDS-020-SMS-010;
      sourcePath = "GAMP/SMT/FS-700-HDS-010-SDS-020-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-700-HDS-010-SDS-020-SMS-010-source-file-classification.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
