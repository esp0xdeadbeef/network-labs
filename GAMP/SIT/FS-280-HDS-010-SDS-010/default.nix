{
  layer = "SIT";
  traceId = "FS-280-HDS-010-SDS-010";
  smsInputs = {
    "FS-280-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-280-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-280-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-280-HDS-010-SDS-010-SMS-010-core-boundary-host-traffic-exception.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-280-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-280-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-280-HDS-010-SDS-010-SMS-020/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-280-HDS-010-SDS-010-SMS-020-core-host-exception-non-exempt-traffic.md";
      role = "canonical-sms-source-stub";
      evidenceBoundary = "source-stub-only";
    };
  };
  evidence = {
    observedResult = "canonical SMS inputs mirrored; no integrated SIT runner or artifact evidence is registered yet";
  };
}
