{
  layer = "SIT";
  traceId = "FS-030-HDS-010-SDS-050";
  smsInputs = {
    "FS-030-HDS-010-SDS-050-SMS-010" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-050-SMS-010;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
