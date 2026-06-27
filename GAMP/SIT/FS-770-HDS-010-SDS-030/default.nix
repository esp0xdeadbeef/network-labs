{
  layer = "SIT";
  traceId = "FS-770-HDS-010-SDS-030";
  smsInputs = {
    "FS-770-HDS-010-SDS-030-SMS-010" = {
      smtRow = ../../SMT/FS-770-HDS-010-SDS-030-SMS-010;
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-030-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-030-SMS-010-source-shape-diagnostic.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-770-HDS-010-SDS-030-SMS-020" = {
      smtRow = ../../SMT/FS-770-HDS-010-SDS-030-SMS-020;
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-030-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-030-SMS-020-source-shape-adapter-selection.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-770-HDS-010-SDS-030-SMS-030" = {
      smtRow = ../../SMT/FS-770-HDS-010-SDS-030-SMS-030;
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-030-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-030-SMS-030-source-shape-diagnostic-detail.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
