{
  layer = "SIT";
  traceId = "FS-730-HDS-010-SDS-010";
  smsInputs = {
    "FS-730-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-730-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-730-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-730-HDS-010-SDS-010-SMS-010-cups-printer-vm.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-730-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-730-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-730-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-730-HDS-010-SDS-010-SMS-020-cups-printer-service-endpoints.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-730-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-730-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-730-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-730-HDS-010-SDS-010-SMS-030-cups-printer-persistence-non-authority.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
