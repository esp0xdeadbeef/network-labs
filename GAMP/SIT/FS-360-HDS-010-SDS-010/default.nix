{
  layer = "SIT";
  traceId = "FS-360-HDS-010-SDS-010";
  smsInputs = {
    "FS-360-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-360-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-360-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-360-HDS-010-SDS-010-SMS-010-downstream-client-public-prefix-authority.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-360-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-360-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-360-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-360-HDS-010-SDS-010-SMS-020-public-prefix-return-route-precondition.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-360-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-360-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-360-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-360-HDS-010-SDS-010-SMS-030-gua-transit-placement-validation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
