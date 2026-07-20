{
  layer = "SIT";
  traceId = "FS-300-HDS-010-SDS-010";
  smsInputs = {
    "FS-300-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-300-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-300-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-300-HDS-010-SDS-010-SMS-010-source-scope-validation.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-300-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-300-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-300-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-300-HDS-010-SDS-010-SMS-020-source-lane-route-metadata.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-300-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-300-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-300-HDS-010-SDS-010-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-300-HDS-010-SDS-010-SMS-030-ineligible-lane-route-rejection.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
