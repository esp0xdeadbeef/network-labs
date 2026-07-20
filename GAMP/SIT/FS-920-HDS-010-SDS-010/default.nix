{
  layer = "SIT";
  traceId = "FS-920-HDS-010-SDS-010";
  smsInputs = {
    "FS-920-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-920-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-920-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-920-HDS-010-SDS-010-SMS-010-modeled-failure-handling.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-920-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-920-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-920-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-920-HDS-010-SDS-010-SMS-020-failure-response-binding.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-920-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-920-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-920-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-920-HDS-010-SDS-010-SMS-030-failure-response-authority-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
