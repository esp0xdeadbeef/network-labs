{
  layer = "SIT";
  traceId = "FS-800-HDS-030-SDS-020";
  smsInputs = {
    "FS-800-HDS-030-SDS-020-SMS-010" = {
      smtRow = ../../SMT/FS-800-HDS-030-SDS-020-SMS-010;
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-record-checks.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
