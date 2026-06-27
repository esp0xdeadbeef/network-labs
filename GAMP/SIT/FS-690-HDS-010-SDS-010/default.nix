{
  layer = "SIT";
  traceId = "FS-690-HDS-010-SDS-010";
  smsInputs = {
    "FS-690-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-690-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-690-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-690-HDS-010-SDS-010-SMS-010-operator-support-view.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-690-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-690-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-690-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-690-HDS-010-SDS-010-SMS-020-operator-support-provenance.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-690-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-690-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-690-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-690-HDS-010-SDS-010-SMS-030-operator-support-non-authority.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
