{
  layer = "SIT";
  traceId = "FS-750-HDS-010-SDS-010";
  smsInputs = {
    "FS-750-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-750-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-750-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-750-HDS-010-SDS-010-SMS-010-receiver-simulation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-750-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-750-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-750-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-750-HDS-010-SDS-010-SMS-020-receiver-payload-ports.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-750-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-750-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-750-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-750-HDS-010-SDS-010-SMS-030-receiver-fixture-non-authority.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
