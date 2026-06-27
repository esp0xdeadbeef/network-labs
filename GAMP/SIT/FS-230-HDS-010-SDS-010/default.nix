{
  layer = "SIT";
  traceId = "FS-230-HDS-010-SDS-010";
  smsInputs = {
    "FS-230-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-230-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-010-public-ingress-return-translation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-230-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-230-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-020-public-ingress-translation-binding.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-230-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-230-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-030-public-ingress-return-authority-separation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
