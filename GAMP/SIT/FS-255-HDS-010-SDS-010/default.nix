{
  layer = "SIT";
  traceId = "FS-255-HDS-010-SDS-010";
  smsInputs = {
    "FS-255-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-255-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-255-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-255-HDS-010-SDS-010-SMS-010-core-role-host-facing-interface-cardinality.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
