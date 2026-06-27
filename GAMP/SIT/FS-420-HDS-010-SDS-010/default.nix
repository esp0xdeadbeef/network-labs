{
  layer = "SIT";
  traceId = "FS-420-HDS-010-SDS-010";
  smsInputs = {
    "FS-420-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-420-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-420-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-420-HDS-010-SDS-010-SMS-010-translation-selection.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-420-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-420-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-420-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-420-HDS-010-SDS-010-SMS-020-selected-translation-record-emission.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-420-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-420-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-420-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-420-HDS-010-SDS-010-SMS-030-translation-authority-containment.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
