{
  layer = "SIT";
  traceId = "FS-960-HDS-010-SDS-012";
  smsInputs = {
    "FS-960-HDS-010-SDS-012-SMS-010" = {
      smtRow = ../../SMT/FS-960-HDS-010-SDS-012-SMS-010;
      sourcePath = "GAMP/SMT/FS-960-HDS-010-SDS-012-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-960-HDS-010-SDS-012-SMS-010-readiness-status-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
