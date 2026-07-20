{
  layer = "SIT";
  traceId = "FS-320-HDS-020-SDS-010";
  smsInputs = {
    "FS-320-HDS-020-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-320-HDS-020-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-320-HDS-020-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-020-SDS-010-SMS-020-renderer-runtime-interface-name-mapping.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-320-HDS-020-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-320-HDS-020-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-320-HDS-020-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-020-SDS-010-SMS-030-renderer-interface-audit-mapping.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
