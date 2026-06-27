{
  layer = "SIT";
  traceId = "FS-390-HDS-010-SDS-010";
  smsInputs = {
    "FS-390-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-390-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-010-public-ipv4-destination-classification.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-390-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-390-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-020-public-ipv4-shortcut-policy.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-390-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-390-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-390-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-390-HDS-010-SDS-010-SMS-030-broad-wan-public-ipv4-denial.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
