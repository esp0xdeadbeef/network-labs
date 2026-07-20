{
  layer = "SIT";
  traceId = "FS-168-HDS-010-SDS-010";
  smsInputs = {
    "FS-168-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-168-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-168-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-168-HDS-010-SDS-010-SMS-010-renderer-consumption-coverage.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
