{
  layer = "SIT";
  traceId = "FS-890-HDS-010-SDS-010";
  smsInputs = {
    "FS-890-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-890-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-890-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-890-HDS-010-SDS-010-SMS-010-operational-record-schema.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-890-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-890-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-890-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-890-HDS-010-SDS-010-SMS-020-structured-operational-record-emission.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-890-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-890-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-890-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-890-HDS-010-SDS-010-SMS-030-incomplete-evidence-classification.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
