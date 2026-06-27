{
  layer = "SIT";
  traceId = "FS-800-HDS-010-SDS-012";
  smsInputs = {
    "FS-800-HDS-010-SDS-012-SMS-010" = {
      smtRow = ../../SMT/FS-800-HDS-010-SDS-012-SMS-010;
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-012-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-012-SMS-010-provider-access-non-authority.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
