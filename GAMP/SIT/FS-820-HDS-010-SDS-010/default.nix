{
  layer = "SIT";
  traceId = "FS-820-HDS-010-SDS-010";
  smsInputs = {
    "FS-820-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-010-secret-source-selection.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-020-secret-source-class-portability.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-030-secret-source-policy-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-050-network-labs-sops-configuration-validation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-060" = {
      smtRow = ../../SMT/FS-820-HDS-010-SDS-010-SMS-060;
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-060/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-060-sops-target-recipient-validation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
