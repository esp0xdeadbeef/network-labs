{
  layer = "SIT";
  traceId = "FS-860-HDS-010-SDS-010";
  smsInputs = {
    "FS-860-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-860-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-010-persistent-service-state.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-860-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-860-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-020-required-state-retention.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-860-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-860-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-030-scoped-storage-binding-emission.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
