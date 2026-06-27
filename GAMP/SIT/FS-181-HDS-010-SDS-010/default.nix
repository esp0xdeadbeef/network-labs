{
  layer = "SIT";
  traceId = "FS-181-HDS-010-SDS-010";
  smsInputs = {
    "FS-181-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-181-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-181-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-181-HDS-010-SDS-010-SMS-010-graph-path-mapping-authority.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
