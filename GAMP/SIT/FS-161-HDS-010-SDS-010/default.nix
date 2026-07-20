{
  layer = "SIT";
  traceId = "FS-161-HDS-010-SDS-010";
  smsInputs = {
    "FS-161-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-161-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-161-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-161-HDS-010-SDS-010-SMS-010-realization-schema-validation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-161-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-161-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-161-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-161-HDS-010-SDS-010-SMS-020-canonical-bundle-production.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-161-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-161-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-161-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-161-HDS-010-SDS-010-SMS-030-platform-binding-validation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
