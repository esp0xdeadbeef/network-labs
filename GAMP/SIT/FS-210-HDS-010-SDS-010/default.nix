{
  layer = "SIT";
  traceId = "FS-210-HDS-010-SDS-010";
  smsInputs = {
    "FS-210-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-210-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-210-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-210-HDS-010-SDS-010-SMS-010-public-ingress-authorization.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-210-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-210-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-210-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-210-HDS-010-SDS-010-SMS-020-public-ingress-tuple-binding.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-210-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-210-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-210-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-210-HDS-010-SDS-010-SMS-030-public-ingress-authority-separation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
