{
  layer = "SIT";
  traceId = "FS-970-HDS-010-SDS-020";
  smsInputs = {
    "FS-970-HDS-010-SDS-020-SMS-010" = {
      smtRow = ../../SMT/FS-970-HDS-010-SDS-020-SMS-010;
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-010-reservation-identity-source-boundary.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-970-HDS-010-SDS-020-SMS-020" = {
      smtRow = ../../SMT/FS-970-HDS-010-SDS-020-SMS-020;
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-020-non-public-reservation-identity-source.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-970-HDS-010-SDS-020-SMS-030" = {
      smtRow = ../../SMT/FS-970-HDS-010-SDS-020-SMS-030;
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-030/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-030-reservation-identity-source-diagnostics.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-970-HDS-010-SDS-020-SMS-040" = {
      smtRow = ../../SMT/FS-970-HDS-010-SDS-020-SMS-040;
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-020-SMS-040/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    command = null;
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
