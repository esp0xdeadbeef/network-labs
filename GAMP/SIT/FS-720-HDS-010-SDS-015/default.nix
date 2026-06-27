{
  layer = "SIT";
  traceId = "FS-720-HDS-010-SDS-015";
  smsInputs = {
    "FS-720-HDS-010-SDS-015-SMS-010" = {
      smtRow = ../../SMT/FS-720-HDS-010-SDS-015-SMS-010;
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-015-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-010-SDS-015-SMS-010-endpoint-bridge-module.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
