{
  layer = "SIT";
  traceId = "FS-770-HDS-010-SDS-010";
  smsInputs = {
    "FS-770-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-770-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-010-SMS-010-common-intent-containerlab-nixos.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-770-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-770-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-010-SMS-020-common-behavior-field-presence.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-770-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-770-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-010-SMS-030-common-intent-realization-classification.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
