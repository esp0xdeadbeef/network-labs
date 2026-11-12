{
  layer = "SIT";
  traceId = "FS-490-HDS-010-SDS-010";
  smsInputs = {
    "FS-490-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-490-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-490-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-490-HDS-010-SDS-010-SMS-010.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-490-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-490-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-490-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-490-HDS-010-SDS-010-SMS-020.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-490-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-490-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-490-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-490-HDS-010-SDS-010-SMS-030.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
