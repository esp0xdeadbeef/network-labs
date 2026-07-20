{
  layer = "SIT";
  traceId = "FS-305-HDS-010-SDS-010";
  smsInputs = {
    "FS-305-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-305-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-305-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-305-HDS-010-SDS-010-SMS-010-virtual-adapter-hygiene-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
