{
  layer = "SIT";
  traceId = "FS-162-HDS-010-SDS-040";
  smsInputs = {
    "FS-162-HDS-010-SDS-040-SMS-010" = {
      smtRow = ../../SMT/FS-162-HDS-010-SDS-040-SMS-010;
      sourcePath = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
