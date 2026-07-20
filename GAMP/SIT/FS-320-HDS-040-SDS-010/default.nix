{
  layer = "SIT";
  traceId = "FS-320-HDS-040-SDS-010";
  smsInputs = {
    "FS-320-HDS-040-SDS-010-SMS-060" = {
      smtRow = ../../SMT/FS-320-HDS-040-SDS-010-SMS-060;
      sourcePath = "GAMP/SMT/FS-320-HDS-040-SDS-010-SMS-060/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-040-SDS-010-SMS-060-nixos-interface-role-classification.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
